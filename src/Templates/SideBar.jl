# Templates/SideBar

const SIDE_BAR = """
sideBar: {
    toolPanels: [
        {
            id: 'customStats',
            labelDefault: 'Custom Stats',
            labelKey: 'customStats',
            iconKey: 'custom-stats',
            toolPanel: CustomFilterPanel,
            toolPanelParams: {
            title: 'Custom Stats',
            },
        },
    ],
    position: 'right',
    defaultToolPanel: 'customStats',
},
onCellValueChanged: (params) => {
    params.api.refreshClientSideRowModel();
}
"""