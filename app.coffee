leafleg = L.leaflegend().color1("yellow").color2("blue").steps(4).xsize(4).ysize(4).makeGrid()
getStyle = (feature) ->

  weight: 1
  opacity: 0.1
  color: "black"
  fillOpacity: 1
  fillColor: leafleg.getColorByRangeAndSize(feature.properties.per_capt,feature.properties.density).c
  className: "range-" + leafleg.getColorByRangeAndSize(feature.properties.per_capt,feature.properties.density).i
  id: "range-" + leafleg.getColorByRangeAndSize(feature.properties.per_capt,feature.properties.density).i

onEachFeature = (feature, layer) ->
  layer.on
    mousemove: mousemove
    mouseout: mouseout
    click: zoomToFeature

  return
mousemove = (e) ->
  layer = e.target
  console.log e

  colorIndex = leafleg.getIndexByColor e
  console.log "index", colorIndex
  legendElement = L.DomUtil.get("#{colorIndex}")
  $(legendElement).css('border', '3px solid black')
  $(legendElement).css('border-radius', '10%')
  # popup.setLatLng e.latlng
  # popup.setContent "<div class=\"marker-title\">" + layer.feature.properties.name + "</div>" + layer.feature.properties.density + " for x values and " + layer.feature.properties.per_capt + " for y values "
  # popup.openOn map  unless popup._map
  # window.clearTimeout closeTooltip
  
  # highlight feature

  layer.setStyle
    weight: 3
    opacity: 0.3
    fillOpacity: 0.9

  layer.bringToFront()  if not L.Browser.ie and not L.Browser.opera
  return
mouseout = (e) ->
  statesLayer.resetStyle e.target
  layer = e.target
  colorIndex = leafleg.getIndexByColor e
  legendElement = document.getElementById(colorIndex)
  $(legendElement).css('border', '0px solid white')
  $(legendElement).css('border-radius', '0%')
  closeTooltip = window.setTimeout(->
    map.closePopup()
    return
  , 100)
  return
zoomToFeature = (e) ->
  map.fitBounds e.target.getBounds()
  return

highlightByLegend = (legendColor) ->


  for key, val of leafleg.options.index_dicts
  
    if val.color.hex() == chroma.color(legendColor).hex()
      xVal = val.x_val
      yVal = val.y_val



  # for key, val of map.getPanes().overlayPane.children[0].children
  #   inner = val.innerHTML.split " "
  #   if inner[7] = chroma.color(legendColor).hex()

  #     inner[6] = "stroke-width='6'"
  #     # innerStrokeText.replace("stroke-width='2'", "stroke-width='6'")



  #     val.innerHTML = inner.join " "
  #     # map.getPanes().overlayPane.children[0].appendChild(val)

  mapLayers = map._layers 


  for key, val of mapLayers
    x_val = val.feature.properties.density if val.feature
    y_val = val.feature.properties.per_capt if val.feature
    layer = val if x_val == xVal and y_val == yVal


  # return layer
  # layer.setStyle
  #   weight: 3
  #   opacity: 0.3
  #   fillOpacity: 0.9



L.mapbox.accessToken = "pk.eyJ1IjoiYXJtaW5hdm4iLCJhIjoiSTFteE9EOCJ9.iDzgmNaITa0-q-H_jw1lJw"
map = L.mapbox.map("map").setView([
  37.8
  -96
], 4)
popup = new L.Popup(autoPan: false)
statesLayer = L.geoJson(statesData,
  style: getStyle
  onEachFeature: onEachFeature
).addTo(map)
legend = L.control(position: "bottomright")

legend.onAdd = (map) ->
  leafleg = L.leaflegend().color1("yellow").color2("blue").steps(4).xsize(4).ysize(4).makeGrid()
  console.log "L", L
  div = undefined
  div = document.getElementById("leaflegend")
  leg_div = leafleg.getLegendHTML(map)
  div

legend.addTo map
$("li .swatch").hover (->
  highlightByLegend $(this).css("background-color") if $(this).attr("id") isnt undefined
  # return
)

closeTooltip = undefined


