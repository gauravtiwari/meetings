$(document).on 'page:change', (event) ->
  $('img.svg').each ->
    $img = jQuery(this)
    imgID = $img.attr('id')
    imgClass = $img.attr('class')
    imgURL = $img.attr('src')
    $.get imgURL, ((data) ->
      # Get the SVG tag, ignore the rest
      $svg = $(data).find('svg')
      # Add replaced image's ID to the new SVG
      if typeof imgID != 'undefined'
        $svg = $svg.attr('id', imgID)
      # Add replaced image's classes to the new SVG
      if typeof imgClass != 'undefined'
        $svg = $svg.attr('class', imgClass + ' inline-svg')
      # Remove any invalid XML tags as per http://validator.w3.org
      $svg = $svg.removeAttr('xmlns:a')
      # Check if the viewport is set, if the viewport is not set the SVG wont't scale.
      if !$svg.attr('viewBox') and $svg.attr('height') and $svg.attr('width')
        $svg.attr 'viewBox', '0 0 ' + $svg.attr('height') + ' ' + $svg.attr('width')
      # Replace image with new SVG
      $img.replaceWith $svg
      return
    ), 'xml'
    return
