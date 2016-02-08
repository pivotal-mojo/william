describe('GroupView', function () {
  beforeEach(function () {
    jasmine.clock().install();
    jasmine.Ajax.install();
  });

  afterEach(function () {
    jasmine.clock().uninstall();
    jasmine.Ajax.uninstall();
  });

  it('shows vms for all the projects', function () {
    var collection = new ProjectCollection(
      [
        {
          name: 'project 1',
          vms: [
            {name: 'project 1 vm 1'},
            {name: 'project 1 vm 2'}
          ]
        },
        {
          name: 'project 2',
          vms: []
        }
      ]
    );
    var view = new GroupView({collection: collection});
    view.render();

    expect(view.$el.text()).toContain('project 1 vm 1');
    expect(view.$el.text()).toContain('project 1 vm 2');
    expect(view.$el.text()).toContain('No vms created');
  });

  it('refreshes the data', function () {
    var collection = new ProjectCollection(
      [
        {
          name: 'project 1',
          vms: [
            {name: 'project 1 vm 1'},
            {name: 'project 1 vm 2'}
          ]
        },
        {
          name: 'project 2',
          vms: []
        }
      ]
    );
    var view = new GroupView({collection: collection});
    view.rerender();

    expect(view.$el.text()).toContain('No vms created');

    jasmine.clock().tick(5001);

    var ajaxRequest = jasmine.Ajax.requests.mostRecent();
    expect(ajaxRequest).not.toBeUndefined();

    ajaxRequest.respondWith(
      {
        status: 200,
        responseText: JSON.stringify([
          {
            name: 'project 1',
            vms: [
              {name: 'project 1 vm 1'},
              {name: 'project 1 vm 2'}
            ]
          },
          {
            name: 'project 2',
            vms: [
              {name: 'project 2 vm 1'}
            ]
          }
        ])
      }
    );

    expect(view.$el.text()).not.toContain('No vms created');
    expect(view.$el.text()).toContain('project 2 vm 1');
  });
});