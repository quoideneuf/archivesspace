describe('Tree JS', function() {
  var request, needsReload;

  function loadTreeModule() {
    if (needsReload) {
      $(window).unbind("hashchange");
      AS.module('tree', true);
    }
  }

  $.fn.scrollTo = function() {
    console.log("scroll somewhere");
  };


  AS.renderTemplate = function(templateId, data, cb) {
    switch(templateId) {
    case "tree_node_resource_template":
      return '<span class="tree-node-text">'+data.title+'</span>';
    default:
      return '<span>whatever</span>';
    }
  };

  beforeEach(function() {
    jasmine.getFixtures().fixturesPath = 'base/jasmine/fixtures';
    loadFixtures("tree.html");
    jasmine.Ajax.install();
    $(document).ready(function() {
      needsReload = _.isUndefined(needsReload) ? false : true
    });
  });

  afterEach(function() {
    jasmine.Ajax.uninstall();
  });

  describe('loading tree: happy path', function() {
    beforeEach(function(done) {
      $('#archives_tree').on("loading.jstree", function() {
        setTimeout(function() {
          request = jasmine.Ajax.requests.mostRecent();
          expect(request.url).toEqual('base/jasmine/fixtures/resource-tree?node_uri=root&hash=');
          request.respondWith(TestResponses.resource_tree.success);
          done();
        }, 500);

        loadTreeModule();
      });
    });

    it('loads the resource tree into the #archives_tree element', function(done) {
      expect($('#archives_tree')[0]).toBeInDOM();

      expect($('ul.jstree-container-ul')[0]).toBeInDOM();
      $('#archives_tree').on("loaded.jstree", function() {
        expect($('li#resource_1')[0]).toBeInDOM();
        done();
      });
    });
  });

  describe('loading tree: sad path', function() {
    beforeEach(function(done) {
      $('#archives_tree').on("loading.jstree", function() {
        setTimeout(function() {
          request = jasmine.Ajax.requests.mostRecent();
          request.respondWith(TestResponses.resource_tree.failure);
          done();
        }, 500);
      });

      loadTreeModule();
    });

    it("stops 'loading' when the backend barfs", function(done) {
      $(document).ready(function() {
        setTimeout(function() {
          expect($('#archives_tree')[0]).not.toHaveClass('jstree-loading');
          done();
        }, 500);
      });
    });

  });
});
