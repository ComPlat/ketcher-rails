
getKetcher = function() {
  var ketcherFrame = document.getElementById("ifKetcher");

  if (ketcherFrame && ("contentDocument" in ketcherFrame))
    return ketcherFrame.contentWindow.ketcher;
  else
    return document.frames['ifKetcher'].window.ketcher;
}

showKetcherModal = function(entityName) {
  var ketcher = getKetcher();
  var molfile = $('textarea#' + entityName + '_molfile').val();
  ketcher.setMolecule(molfile);
  $('#ketcherModal').modal('show');
}

saveStructure = function(entityName) {
  var ketcher = getKetcher();

  var molfile = ketcher.getMolfile();
  var svg = ketcher.getSVG();
  $('textarea#' + entityName + '_molfile').html(molfile);
  $('input#svg').val(svg); // set SVG value from the editor
  $('#ketcherModal').modal('hide');
};

updateMolfileFromFileInput = function (e, entityName) {
  var file = $('input#' + entityName + '_file_molfile').val();
  var reader = new FileReader();
  reader.readAsText(e.files[0]);
  reader.onload = function(e) {
    $('textarea#' + entityName + '_molfile').html(e.target.result);
  };
}
