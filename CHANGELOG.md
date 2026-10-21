# Changelog

## 1.3.27

- The layout preview renders in the administration's public siteaccess (`expLayoutsPreviewSiteAccess` of
  explayouts: `explayouts.ini [PreviewSettings] SiteAccess`, FrontSiteAccess, related siteaccesses, DefaultAccess),
  never in one with another database; without one it says so. With an explayouts that lacks the class the preview
  stays in DefaultAccess as before.
- The rule forms store every target and condition type the resolver knows (module targets of admin layouts,
  `ibexa_content_type`).
- The Layouts tab of the admin menu has an icon (admin4), the one of the dashboard's Layouts action.
- Arabic, Persian, Pashto and Kurdish (Kurmanji) translations; Spanish addresses the user with "tú" throughout;
  the ten translations of 1.3.26 carry the new preview message.
