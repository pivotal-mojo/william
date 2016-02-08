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
        '<div class="project-vms">' +
        '<h3>VMs for <%= project.name %></h3>' +
        '<% if (project.vms.length === 0) { %>' +
        'No vms created' +
        '<% } else { %>' +
        '<table class="vms">' +
        '<thead>' +
        '<tr>' +
        '<th>Name</th>' +
        '<th>CPUs</th>' +
        '<th>Memory(MB)</th>' +
        '<th>Storage(GB)</th>' +
        '<th>Operating System</th>' +
        '<th>Status</th>' +
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