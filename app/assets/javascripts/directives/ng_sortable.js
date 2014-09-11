angular.module('ui.sortable').value('uiSortableConfig', {
  sortable: {
    connectWith: '.feed-column',
    revert: true,
    handle: '.handle',
    scroll: false,
    stop: 'update_positions'
  }
});