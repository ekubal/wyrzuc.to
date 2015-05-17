$(function(){

  $.each(wastes_urls, function(i, url) {
    $.ajax({
      url: '/geolocations/' + url,
      dataType: 'json'
    }).done(function(data){
      addToMrkersCache(url, data)
      markerClusterer.addMarkers(markersCache[url], false);
    });
  });

  var addToMrkersCache = function(key, items){
    markersCache[key] = items.map(function(item){
      var marker =  new google.maps.Marker({
        icon: "/markers/" + key + ".png",
        title: item[0],
        position: new google.maps.LatLng(item[1], item[2])
      });
      google.maps.event.addListener(marker, 'click', function() {
        infowindow.setContent("<span style='color: black;'>"+this.title+"</span>");
        infowindow.open(map, this);
      });
      return marker;
    });
  }

  $(".x-left-button").on('click', function(a) {
    a.preventDefault();
    var click     = $(this).data('click');
    var object_id = $(this).attr('id');

    if($(window).width() <= 640){
      $.ajax({
        url: '/place_info/all_places',
        data: { kind: object_id},
        dataType: 'script'
      });
    } else {
      if(click){
        markerClusterer.addMarkers(markersCache[object_id], false);
      }
      else {
        markerClusterer.removeMarkers(markersCache[object_id], false);
      }
      $(this).data("click", !click);
    }
  });

  $(document).delegate('.sidebar .handle', 'click', function(e) {
      e.preventDefault();
      $('body').toggleClass('sidebarOpen');
  });

  $.each($('.types a'), function(it, a) {
    a = $(a);
    a.data('width', a.width() + 32);
    a.css('width', '45px');
    a.hover(
      function(){
        $(this).css('width', $(this).data('width'));
      },
      function(){
        $(this).css('width', '45px');
      }
    )
  })
});
