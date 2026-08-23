---
name: download-song
description: Download songs, albums, or playlists from YouTube/YouTube Music into Stone's Apple Music library using the project's xyt script. Trigger whenever the user provides one or more YouTube/YouTube Music URLs and asks to download, add to music library, save song(s), grab this track/album/playlist, or similar.
---

# Download songs into Stone's Music library

Stone's music library is the standard Apple Music auto-import folder. `xyt` (bash wrapper) and `xyt.py` (Python deduper/mover) live in `~/dotfiles/scripts/.local/bin/` and are stowed onto `PATH` at `~/.local/bin/xyt` — runnable from any directory. They:

1. Use `yt-dlp` to download to `~/.local/bin/songs/` (symlinked to `~/dotfiles/scripts/.local/bin/songs/`) as AAC m4a with embedded thumbnails and metadata.
2. Track downloaded IDs in `~/dotfiles/scripts/.local/bin/downloaded.txt` so re-runs skip duplicates.
3. Move new files into `~/Music/Music/Media.localized/Automatically Add to Music.localized/` (Apple Music auto-imports anything dropped here).
4. Dedupe by normalized filename against the existing library (`~/Music/Music/Media.localized/Music/`).

## How to invoke

Always use the `xyt` command. Do not bypass it by calling `yt-dlp` directly, even for batching — Stone has confirmed it's the canonical entry point.

**Single URL:**
```bash
xyt "<url>"
```

**Multiple URLs — loop the command:**
```bash
for url in "<url1>" "<url2>" "<url3>"; do xyt "$url"; done
```

Playlist URLs (e.g. `music.youtube.com/playlist?list=...`) are expanded by yt-dlp automatically — pass the playlist URL itself, not the individual tracks.

## Notes

- The script runs `brew upgrade yt-dlp` on every invocation. That's intentional; don't strip it.
- Downloads are long-running; prefer `run_in_background: true` and check the output file when notified.
- Apple Music must be running (or will be auto-launched) for the auto-add folder to pick up new tracks.
- If a duplicate is detected by normalized filename, `xyt.py` deletes the new download rather than overwriting.
- Don't edit `downloaded.txt` manually; yt-dlp owns it.
- After completion, briefly report what was added vs. skipped (the mover prints `Added:` / `Skipping duplicate:` lines).
