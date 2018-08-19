$(document).ready(function() {
  $(".product-grid__add-to-cart").on("click", function() {
    console.log("Data: " + $(this).attr("data-id"));
  });
});
