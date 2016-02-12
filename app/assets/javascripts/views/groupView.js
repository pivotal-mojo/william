window.GroupView = Backbone.View.extend({
  initialize: function () {
    this.listenTo(this.collection, 'reset', this.rerender);
  },
  render: function () {
    this.$el.html(_.template(this.template())({projects: this.collection.toJSON()}));
    return this;
  },
  template: function () {
    return '<% _.each(projects, function(project) { %>' +
        '<div class="project-vms card">' +
        '<h4>VMs for Project <%= project.name %></h4>' +
        '<% if (project.vms.length === 0) { %>' +
        '<div class="empty">No vms created</div>' +
        '<% } else { %>' +
        '<table class="zebra-stripe">' +
        '<thead>' +
        '<tr>' +
        '<th class="vm-name">Name</th>' +
        '<th class="cpu-count">CPUs</th>' +
        '<th class="memory-amount">Memory (MB)</th>' +
        '<th class="storage-amount">Storage (GB)</th>' +
        '<th class="operating-system">Operating System</th>' +
        '<th class="vm-status">Status</th>' +
        '</tr>' +
        '</thead>' +
        '<tbody>' +
        '<% _.each(project.vms, function(vm) { %>' +
        '<tr>' +
        '<td><%= vm.name %></td>' +
        '<td><%= vm.cpus %></td>' +
        '<td><%= vm.memory %></td>' +
        '<td><%= vm.storage %></td>' +
        '<td><%= vm.operating_system %></td>' +
        '<td><%= vm.status %></td>' +
        '</tr>' +
        '<% }); %>' +
        '</tbody>' +
        '</table>' +
        '<% } %>' +
        '</div>' +
        '<% }); %>';

  },
  rerender: function () {
    this.render();
    this.start();
  },
  start: function () {
    setTimeout(_.bind(function () {
      this.collection.fetch({reset: true});
    }, this), 5000);
  }
});