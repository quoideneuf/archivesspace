describe('Tree JS', function() {

  beforeEach(function() {
    jasmine.getFixtures().fixturesPath = 'base/jasmine/fixtures';
    loadFixtures("tree.html");

    AS.renderTemplate = function(templateId, data, cb) {
      console.log(templateId);
      switch(templateId) {
      case "tree_node_resource_template":
        return '<span class="tree-node-text">'+data.title+'</span>';
      default:
        return '<span>whatever</span>';
      }
    };

  });

  it('loads JSTree onto the #archives_tree element', function(done) {
    $(document).ready(function() {
      expect($('#archives_tree')[0]).toBeInDOM();
      expect($('ul.jstree-container-ul')[0]).toBeInDOM();
      $('#archives_tree').on("loaded.jstree", function() {
        expect($('li#resource_1')[0]).toBeInDOM();
        done();
      });
    });
  });
});
