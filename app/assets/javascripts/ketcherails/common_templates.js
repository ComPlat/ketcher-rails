// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
saveStructure = function() {
  var ketcherFrame = document.getElementById("ifKetcher");
  var ketcher = null;

  if (ketcherFrame && ("contentDocument" in ketcherFrame))
    ketcher = ketcherFrame.contentWindow.ketcher;
  else
    ketcher = document.frames['ifKetcher'].window.ketcher;

  var molfile = ketcher.getMolfile();
  var svg = ketcher.getSVG();
  $('textarea#common_template_molfile').html(molfile);
  $('input#svg').val(svg); //set SVG value from the editor
  $('#ketcherModal').modal('hide');
};

updateMolfileFromFileInput = function (e) {
  var file = $('input#common_template_file_molfile').val();
  var reader = new FileReader();
  reader.readAsText(e.files[0]);
  reader.onload = function(e) {
    $('textarea#common_template_molfile').html(e.target.result);
  };
}
