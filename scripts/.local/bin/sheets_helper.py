#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "google-auth",
#   "google-api-python-client",
# ]
# ///
"""
Google Sheets job application tracker.

Usage:
  sheets_helper.py append <position> <company> <industry> <location> [date_posted] [date_applied] [connections] [cover_letter] [resume_upload] [resume_form] [salary] [notes] [status]
  sheets_helper.py read
  sheets_helper.py update <row> <col> <value>

Reads SPREADSHEET_ID and SHEET_NAME from environment, or falls back to the
constants below. Credentials are loaded from ~/.config/stone-zone/google-credentials.json.
"""

import os
import re
import sys
from datetime import date, datetime

from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build

# --- configure these or set as environment variables ---
SPREADSHEET_ID = os.getenv("SHEETS_SPREADSHEET_ID", "1VCVcG37GbZ-Ossf-1UlQEhySnbnB8NftyelbO5QjoFk")
SHEET_NAME     = os.getenv("SHEETS_SHEET_NAME", "Job Grind")
CREDS_PATH     = os.getenv("SHEETS_CREDS_PATH", os.path.expanduser("~/.config/stone-zone/google-credentials.json"))
SCOPES         = ["https://www.googleapis.com/auth/spreadsheets"]

# Column layout (A-Q)
COLUMNS = [
    "Position", "Company", "Industry", "Role", "Location",
    "Date Posted", "Date Applied", "Connections?", "Cover Letter",
    "Résumé upload?", "Résumé Form?", "Salary Range", "Notes",
    "Status", "Latest word", "contact 1", "SHADE",
]


def _service():
    creds = Credentials.from_service_account_file(CREDS_PATH, scopes=SCOPES)
    return build("sheets", "v4", credentials=creds).spreadsheets()


def _get_sheet_id(svc):
    meta = svc.get(spreadsheetId=SPREADSHEET_ID, fields="sheets.properties").execute()
    return next(
        s["properties"]["sheetId"]
        for s in meta["sheets"]
        if s["properties"]["title"] == SHEET_NAME
    )


def get_status_options():
    svc = _service()
    result = svc.get(
        spreadsheetId=SPREADSHEET_ID,
        ranges=[f"{SHEET_NAME}!N2"],
        includeGridData=True,
        fields="sheets.data.rowData.values.dataValidation",
    ).execute()
    try:
        validation = result["sheets"][0]["data"][0]["rowData"][0]["values"][0]["dataValidation"]
        return [c["userEnteredValue"] for c in validation["condition"]["values"]]
    except (KeyError, IndexError):
        return []


def set_status_options(options):
    svc = _service()
    sheet_id = _get_sheet_id(svc)
    svc.batchUpdate(
        spreadsheetId=SPREADSHEET_ID,
        body={"requests": [{
            "setDataValidation": {
                "range": {
                    "sheetId": sheet_id,
                    "startRowIndex": 1,
                    "startColumnIndex": 13,
                    "endColumnIndex": 14,
                },
                "rule": {
                    "condition": {
                        "type": "ONE_OF_LIST",
                        "values": [{"userEnteredValue": v} for v in options],
                    },
                    "showCustomUi": True,
                    "strict": True,
                },
            }
        }]},
    ).execute()
    print(f"Status dropdown updated: {', '.join(options)}")


def add_status_option(value):
    current = get_status_options()
    if value in current:
        print(f"'{value}' already exists. Current options: {', '.join(current)}")
        return
    new_options = current + [value]
    set_status_options(new_options)
    print(f"Added '{value}'. All options: {', '.join(new_options)}")


def get_status_color_rules():
    svc = _service()
    sheet_id = _get_sheet_id(svc)
    result = svc.get(
        spreadsheetId=SPREADSHEET_ID,
        fields="sheets.conditionalFormats",
    ).execute()
    rules = []
    for sheet in result.get("sheets", []):
        if sheet.get("conditionalFormats"):
            for cf in sheet["conditionalFormats"]:
                for r in cf.get("ranges", []):
                    if r.get("sheetId") == sheet_id and r.get("startColumnIndex") == 13:
                        rules.append(cf)
                        break
    return rules


def add_status_color(status_value, red, green, blue):
    svc = _service()
    sheet_id = _get_sheet_id(svc)
    svc.batchUpdate(
        spreadsheetId=SPREADSHEET_ID,
        body={"requests": [{
            "addConditionalFormatRule": {
                "rule": {
                    "ranges": [{
                        "sheetId": sheet_id,
                        "startRowIndex": 1,
                        "endRowIndex": 791,
                        "startColumnIndex": 0,
                        "endColumnIndex": 17,
                    }],
                    "booleanRule": {
                        "condition": {
                            "type": "CUSTOM_FORMULA",
                            "values": [{"userEnteredValue": f'=$N2="{status_value}"'}],
                        },
                        "format": {
                            "backgroundColor": {"red": red, "green": green, "blue": blue},
                        },
                    },
                },
                "index": 0,
            }
        }]},
    ).execute()
    print(f"Color rule added for '{status_value}'")


STATUS_TIERS = {
    "offer": 0,
    "onsite": 1,
    "pending": 1,
    "interview": 2,
    "oa": 3,
    "online assessment": 3,
    "sent": 4,
    "rejection": 5,
    "not under consideration": 5,
}
DEFAULT_STATUS_TIER = 4


def status_tier(status):
    if not status:
        return DEFAULT_STATUS_TIER
    return STATUS_TIERS.get(status.strip().lower(), DEFAULT_STATUS_TIER)


# Canonical Status values (must match the dropdown in column N exactly, casing
# included) keyed by every accepted spelling/alias, lower-cased. This is the
# single source of truth that keeps the Status column consistent: writes are
# normalized through it, unknown values are rejected, and `normalize-statuses`
# (plus every sort) heals any drift back to these spellings. To add a new status,
# add it to the sheet's dropdown AND add its aliases here.
CANONICAL_STATUS = {
    "- -": "- -", "--": "- -", "": "- -",
    "draft": "draft",
    "sent": "sent", "applied": "sent",
    "phone call": "phone call", "phone": "phone call", "phone screen": "phone call",
    "interview": "interview",
    "oa": "OA", "online assessment": "OA", "assessment": "OA",
    "onsite": "onsite", "on-site": "onsite", "on site": "onsite",
    "offer": "offer",
    "pending": "pending",
    "rejection": "rejection", "rejected": "rejection", "reject": "rejection",
    "not under consideration": "Not Under Consideration",
}


def canonical_status(value):
    """Canonical spelling for `value`, or None if it isn't a known status."""
    return CANONICAL_STATUS.get((value or "").strip().lower())


def normalize_status(value):
    """Strict normalize for writes: return the canonical spelling, or exit with a
    helpful error listing the valid statuses. Blank stays blank."""
    if value is None or not str(value).strip():
        return value
    canon = canonical_status(value)
    if canon is None:
        valid = ", ".join(sorted(set(CANONICAL_STATUS.values())))
        raise SystemExit(f"Unknown status {value!r}. Valid statuses: {valid}")
    return canon


def parse_date_for_sort(s):
    """Parse a date_applied cell into (sort_key, display, is_fully_dated).

    Fully dated rows (year-month-day) get a sortable ISO key and are
    placed in the sorted region. Partial dates ('Apr-2026'), 'IDK',
    blanks, and unparseable strings are treated as undated and pushed
    to the bottom in their original relative order.
    """
    if not s:
        return ("", "", False)
    s = s.strip()
    if not s or s.upper() == "IDK":
        return ("", s, False)
    if re.fullmatch(r"\d{4}-\d{2}-\d{2}", s):
        return (s, s, True)
    for fmt in ("%b-%d-%Y", "%B-%d-%Y"):
        try:
            iso = datetime.strptime(s, fmt).strftime("%Y-%m-%d")
            return (iso, iso, True)
        except ValueError:
            pass
    for fmt in ("%b-%Y", "%B-%Y"):
        try:
            partial = datetime.strptime(s, fmt).strftime("%Y-%m")
            return ("", partial, False)
        except ValueError:
            pass
    return ("", s, False)


def normalize_and_sort(direction="desc"):
    svc = _service()
    result = svc.values().get(
        spreadsheetId=SPREADSHEET_ID,
        range=f"{SHEET_NAME}!A2:Q",
    ).execute()
    rows = result.get("values", [])
    if not rows:
        print("No data to sort.")
        return
    rows = [r + [""] * (17 - len(r)) for r in rows]

    processed, dated_count = [], 0
    for r in rows:
        if not any((c or "").strip() for c in r):
            continue
        sort_key, display, is_dated = parse_date_for_sort(r[6])
        r[6] = display
        # Self-heal Status drift (e.g. a value typed straight into the UI):
        # snap any recognized alias back to its canonical spelling. Unknown
        # values are left untouched so nothing is silently destroyed.
        canon = canonical_status(r[13])
        if canon is not None:
            r[13] = canon
        if is_dated:
            dated_count += 1
        processed.append((sort_key, r))

    # Two-pass stable sort: date within tier (undated rows share sort_key ""
    # and sink to the bottom of their own tier, not the whole sheet), then
    # tier (status hierarchy) as the dominant key.
    processed.sort(key=lambda x: x[0], reverse=(direction == "desc"))
    processed.sort(key=lambda x: status_tier(x[1][13]))
    sorted_rows = [r for _, r in processed]

    end_row = len(sorted_rows) + 1
    svc.values().update(
        spreadsheetId=SPREADSHEET_ID,
        range=f"{SHEET_NAME}!A2:Q{end_row}",
        valueInputOption="RAW",
        body={"values": sorted_rows},
    ).execute()
    statuses = [[r[13]] for r in sorted_rows]
    svc.values().update(
        spreadsheetId=SPREADSHEET_ID,
        range=f"{SHEET_NAME}!N2:N{end_row}",
        valueInputOption="USER_ENTERED",
        body={"values": statuses},
    ).execute()
    print(f"Sorted {len(sorted_rows)} rows ({dated_count} dated, {len(sorted_rows) - dated_count} undated, direction={direction}).")


def append_job(
    position, company, industry, location,
    date_posted="N/A", date_applied=None,
    connections="None", cover_letter="None",
    resume_upload="Yes", resume_form="No",
    salary="TBD", notes="", status="sent",
):
    if date_applied is None:
        date_applied = date.today().strftime("%Y-%m-%d")
    status = normalize_status(status)  # reject/repair off-list statuses up front
    # Append all fields as raw text except status (dropdown requires USER_ENTERED)
    row = [
        position, company, industry, "Software", location,
        date_posted, date_applied, connections, cover_letter,
        resume_upload, resume_form, salary, notes,
    ]
    svc = _service()
    result = svc.values().append(
        spreadsheetId=SPREADSHEET_ID,
        range=f"{SHEET_NAME}!A:N",
        valueInputOption="RAW",
        body={"values": [row]},
    ).execute()
    # Extract the row number that was just appended and set status via USER_ENTERED
    updated_range = result["updates"]["updatedRange"]
    row_num = int(updated_range.split("!")[1].lstrip("ABCDEFGHIJKLMNOPQRSTUVWXYZ").split(":")[0])
    svc.values().update(
        spreadsheetId=SPREADSHEET_ID,
        range=f"{SHEET_NAME}!N{row_num}",
        valueInputOption="USER_ENTERED",
        body={"values": [[status]]},
    ).execute()
    print(f"Logged: {date_applied} | {company} | {position} | {location} | {status}")
    normalize_and_sort("desc")


def normalize_statuses(apply=False):
    """Scan column N and snap every recognized status to its canonical spelling
    (e.g. 'rejected' -> 'rejection'). Dry-run by default; pass apply=True to
    write. Unknown values are reported but left unchanged."""
    svc = _service()
    vals = svc.values().get(
        spreadsheetId=SPREADSHEET_ID, range=f"{SHEET_NAME}!N2:N",
    ).execute().get("values", [])
    out, fixes, unknown = [], [], []
    for i, r in enumerate(vals, start=2):
        cur = r[0] if r else ""
        canon = canonical_status(cur)
        if canon is None:
            out.append([cur])
            if (cur or "").strip():
                unknown.append((i, cur))
        else:
            out.append([canon])
            if canon != cur:
                fixes.append((i, cur, canon))

    for i, old, new in fixes:
        print(f"  N{i}: {old!r} -> {new!r}")
    for i, val in unknown:
        print(f"  N{i}: {val!r} UNKNOWN (left unchanged)")

    if not fixes:
        print("All statuses already canonical." if not unknown
              else f"No fixable rows; {len(unknown)} unknown value(s) above.")
        return
    if not apply:
        print(f"{len(fixes)} change(s) would be applied. Re-run with --apply.")
        return
    svc.values().update(
        spreadsheetId=SPREADSHEET_ID,
        range=f"{SHEET_NAME}!N2:N{len(out) + 1}",
        valueInputOption="USER_ENTERED",
        body={"values": out},
    ).execute()
    print(f"Applied {len(fixes)} fix(es).")


def read_jobs():
    result = _service().values().get(
        spreadsheetId=SPREADSHEET_ID,
        range=f"{SHEET_NAME}!A:Q",
    ).execute()
    rows = result.get("values", [])
    if not rows:
        print("No data found.")
        return
    # Number rows by their true 1-based sheet row (header = row 1) so the value
    # shown here is exactly what `update <row> <col> <value>` expects.
    for i, row in enumerate(rows, start=1):
        print(f"{i:>3}: {' | '.join(row)}")


def standardize_fonts(font_family="Arial", font_size=10):
    svc = _service()
    sheet_id = _get_sheet_id(svc)
    requests = [
        {
            "repeatCell": {
                "range": {"sheetId": sheet_id},
                "cell": {
                    "userEnteredFormat": {
                        "textFormat": {
                            "fontFamily": font_family,
                            "fontSize": font_size,
                        }
                    }
                },
                "fields": "userEnteredFormat.textFormat.fontFamily,userEnteredFormat.textFormat.fontSize",
            }
        }
    ]
    svc.batchUpdate(
        spreadsheetId=SPREADSHEET_ID,
        body={"requests": requests},
    ).execute()
    print(f"Standardized font to {font_family} {font_size}pt across '{SHEET_NAME}'")


DROPDOWN_COLS = {"N"}  # Status column uses data validation

def update_cell(row_number, col, value):
    """row_number is 1-indexed (row 1 = header). col is a letter like A-Q."""
    if col.upper() in DROPDOWN_COLS:
        value = normalize_status(value)  # keep Status column canonical
    input_option = "USER_ENTERED" if col.upper() in DROPDOWN_COLS else "RAW"
    _service().values().update(
        spreadsheetId=SPREADSHEET_ID,
        range=f"{SHEET_NAME}!{col.upper()}{int(row_number)}",
        valueInputOption=input_option,
        body={"values": [[value]]},
    ).execute()
    print(f"Updated {col.upper()}{row_number} = {value}")


USAGE = """
Commands:
  append <position> <company> <industry> <location> [date_posted] [date_applied] [connections] [cover_letter] [resume_upload] [resume_form] [salary] [notes] [status]
  read
  sort [desc|asc]
  update <row_number> <col> <value>
  format [font_family] [font_size]
  add-status <value>
  list-status
  normalize-statuses [--apply]
""".strip()

if __name__ == "__main__":
    args = sys.argv[1:]
    if not args:
        print(USAGE)
        sys.exit(1)

    cmd = args[0]
    if cmd == "append":
        if len(args) < 5:
            print("Usage: append <position> <company> <industry> <location> [...]")
            sys.exit(1)
        append_job(*args[1:14])
    elif cmd == "read":
        read_jobs()
    elif cmd == "sort":
        direction = args[1] if len(args) > 1 else "desc"
        normalize_and_sort(direction)
    elif cmd == "update":
        if len(args) < 4:
            print("Usage: update <row_number> <col> <value>")
            sys.exit(1)
        update_cell(args[1], args[2], args[3])
    elif cmd == "format":
        font_family = args[1] if len(args) > 1 else "Arial"
        font_size = int(args[2]) if len(args) > 2 else 10
        standardize_fonts(font_family, font_size)
    elif cmd == "add-status":
        if len(args) < 2:
            print("Usage: add-status <value>")
            sys.exit(1)
        add_status_option(args[1])
    elif cmd == "list-status":
        options = get_status_options()
        print("Current status options:", ", ".join(options) if options else "(none found)")
    elif cmd == "normalize-statuses":
        normalize_statuses(apply="--apply" in args[1:])
    elif cmd == "set-status-color":
        if len(args) < 5:
            print("Usage: set-status-color <value> <red 0-1> <green 0-1> <blue 0-1>")
            sys.exit(1)
        add_status_color(args[1], float(args[2]), float(args[3]), float(args[4]))
    else:
        print(USAGE)
        sys.exit(1)
