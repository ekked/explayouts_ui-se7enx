<?php /* #?ini charset="utf-8"?

[NavigationPart]
Part[ezexplayoutsuinavigationpart]=Layouts

[TopAdminMenu]
Tabs[]=explayouts_ui_dashboard

[Topmenu_explayouts_ui_dashboard]
NavigationPartIdentifier=ezexplayoutsuinavigationpart
Name=Layouts
Tooltip=Layouts dashboard
URL[]
URL[default]=explayouts_ui/dashboard
Enabled[]
Enabled[default]=true
Enabled[browse]=false
Enabled[edit]=false
Shown[]
Shown[default]=true
Shown[edit]=true
Shown[navigation]=true
Shown[browse]=true
# The policy of the view the tab opens (explayouts_ui/dashboard needs
# explayouts_ui/read): with explayouts/read the tab showed for users the view
# then refused, and stayed hidden for users who could open it.
PolicyList[]=explayouts_ui/read

[Leftmenu_explayouts_ui_dashboard]
Name=Layouts
Links[]
LinkNames[]
Links[Layout mappings]=explayouts_ui/rule_list
LinkNames[Layout mappings]=Layout mappings
Links[Layouts]=explayouts_ui/layout_list
LinkNames[Layouts]=Layouts
Links[Shared layouts]=explayouts_ui/shared_layouts_list
LinkNames[Shared layouts]=Shared layouts
Links[Components]=explayouts_ui/components
LinkNames[Components]=Components
Links[Import]=explayouts_ui/transfer_import
LinkNames[Import]=Import
Links[Template editor]=explayouts_ui/template_editor
LinkNames[Template editor]=Template editor
Links[Setup]=explayouts_ui/setup
LinkNames[Setup]=Setup

*/ ?>
