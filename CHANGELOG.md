# Changelog

## Unreleased

- The layout preview renders in the administration's public siteaccess (`expLayoutsPreviewSiteAccess` of
  explayouts: `explayouts.ini [PreviewSettings] SiteAccess`, FrontSiteAccess, related siteaccesses, DefaultAccess),
  never in one with another database; without one it says so. With an explayouts that lacks the class the preview
  stays in DefaultAccess as before.
- The rule forms store every target and condition type the resolver knows (module targets of admin layouts,
  `ibexa_content_type`).
