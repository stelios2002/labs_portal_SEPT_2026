document.addEventListener("turbo:load", () => {
  const tz = Intl.DateTimeFormat().resolvedOptions().timeZone
  if (document.cookie.indexOf(`browser_tz=${tz}`) === -1) {
    document.cookie = `browser_tz=${tz}; path=/; max-age=31536000`
  }
})