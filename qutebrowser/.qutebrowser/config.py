config.load_autoconfig()
config.set("content.pdfjs", True)
c.url.searchengines = {
  "DEFAULT": "https://www.google.com/search?q={}",
  "g": "https://www.google.com/search?q={}",
}
c.url.default_page = "https://www.google.com"          # page on new windows/tabs
c.url.start_pages = ["https://www.google.com"]         # pages opened at startup

