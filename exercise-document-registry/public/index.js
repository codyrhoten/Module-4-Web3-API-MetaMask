$(document).ready(function() {
  try {
    window.ethereum.enable();
  } catch (e) {
    alert("Access Denied.");
  }

  const documentRegistryContractAddress = "";

  const documentRegistryContractABI = [];

  const IPFS = window.IpfsApi("localhost", "5001");
  const Buffer = IPFS.Buffer;

  // === User Interface Handlers Start ===

  $("#linkHome").click(function() {
    showView("viewHome");
  });

  $("#linkSubmitDocument").click(function() {
    showView("viewSubmitDocument");
  });

  $("#linkGetDocuments").click(function() {
    $("#viewGetDocuments div").remove();
    showView("viewGetDocuments");
    viewGetDocuments();
  });

  // Attach AJAX "loading" event listener
  $(document).on({
    ajaxStart: function() {
      $("#loadingBox").show();
    },
    ajaxStop: function() {
      $("#loadingBox").hide();
    }
  });

  function showView(viewName) {
    // Hide all views and show the selected view only
    $("main > section").hide();
    $("#" + viewName).show();
  }

  function showInfo(message) {
    $("#infoBox>p").html(message);
    $("#infoBox").show();
    $("#infoBox>header").click(function() {
      $("#infoBox").hide();
    });
  }

  function showError(errorMsg) {
    $("#errorBox>p").html("Error: " + errorMsg);
    $("#errorBox").show();
    $("#errorBox>header").click(function() {
      $("#errorBox").hide();
    });
  }

  $("#documentUploadButton").click(uploadDocument);

  // === User Interface Interactions End ===

  function uploadDocument() {
    // Todo: Implementation
  }

  function viewGetDocuments() {
    // Todo: Implementation
  }
});
