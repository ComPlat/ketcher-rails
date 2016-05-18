module Ketcherails
  class SVGProcessor
    attr_accessor :margins, :remove_internal_transform
    attr_reader :min,:max,:svg,:shift

    def initialize(svg="",**options)
      @svg = Nokogiri::XML(svg)
      @min,@max=[nil,nil],[nil,nil]
      @margins= (options[:margins].is_a?(Array)&& options[:margins])  || [10,10]
      svg = @svg.at_css("svg")
      original_w = svg  && svg["width"].to_f
      original_h = svg  && svg["height"].to_f
      @width = (options[:width].is_a?(Integer) && options[:width]) || original_w
      @height = (options[:height].is_a?(Integer) && options[:height]) || original_h
      #@remove_internal_transform = true
      @transforms = []
      @shift=[nil,nil]
    end

    def paths
      @paths = @svg.css("//path")
    end

    def circles
      @circles = @svg.css("//circle")
    end

    def texts
      @texts = @svg.css("//text")
    end

    def clean
      @svg.search('rect').each do |rect|
        if [rect["x"],rect["y"],rect["width"],rect["height"]]== ["0","0","10","10"]
          rect.remove
        end
      end
      @svg.search('desc').each(&:remove)

    end

    def redefine_window_size
      svg=@svg.at_css("svg")
      svg["width"] = @width
      svg["height"] = @height
    end

    def find_extrema
      get_internal_transform_shift
      #remove_all_internal_transform if remove_internal_transform
      path_extrema
      circle_extrema
      text_extrema
      shift_extrema
      self
    end

    def get_internal_transform_shifts
      paths.each do |path|
        transformation = path["transform"]
        if transformation.match(/^matrix/)
          matrix = get_matrix_from_transform_matrix(transformation)
          shift = get_translation_from_matrix(matrix)
        elsif transformation.match(/^translate/)
          shift = get_translation_from_transform_translate(transformation)
        end

        @transforms << shift
      end
    end

    def get_internal_transform_shift
      get_internal_transform_shifts
      @shift=transform_count
    end

    def remove_all_internal_transform
      [paths,circles].each do |node_set|
        node_set.each{|node| node["transform"]=""}
      end
    end

    def centered_and_scaled_svg
      clean
      find_extrema
      center_and_scale
      redefine_window_size
      to_xml
    end


    def path_extrema(ind=nil)
      if ind
        splitxy_for_path(ind)
        minmax
        return [@min,@max]
      end
      paths.each do |path|
        coordinates = splitxy_for_path(path["d"])
        minmax(coordinates)
      end
    end

    def text_extrema
      texts.each do |text|
        if !text["style"].match(/display:\s*none/)
          coordinates = splitxy_for_text(text)
          minmax(coordinates)
        end
      end
    end

    def circle_extrema
      circles.each do |circle|
        if !circle["style"].match(/display:\s*none/)

          coordinates = splitxy_for_circle(circle)
          minmax(coordinates)
        end
      end
    end

    def shift_extrema
      shiftx,shifty = *@shift
      minx,miny = *@min
      maxx,maxy = *@max
      @min=[minx+shiftx, miny+shifty]
      @max=[maxx+shiftx, maxy+shifty]
    end


    def viewbox
      @viewbox = @svg.at_css("svg")["viewbox"]#.split(/,| /)
    end

    def preserve_aspect_ratio(t="xMinYMin")
      @svg.at_css("svg")["preserveAspectRatio"]=t
      self
    end

    def center_and_scale
      return if ([@min,@max].flatten.compact.empty?)
      svg = @svg.at_css("svg")
      marx,mary = *@margins
      height = svg["height"].to_f-mary*2
      width = svg["width"].to_f-marx*2
      minx,miny = *@min
      maxx,maxy = *@max
      w,h = maxx-minx,maxy-miny
      scale_low,scale_high = *([width/w , height/h].sort)

      if width/w <height/h
        #then recenter along y
        translation = [-minx*scale_low+marx,-miny*scale_low+mary+(scale_high-scale_low)*h/2]
      else
        #recenter along x
        translation = [-minx*scale_low+marx+(scale_high-scale_low)*w/2,-miny*scale_low+mary]
      end

      translate = "translate(%i,%i) " %translation
      scale = "scale(%.2f) " %scale_low
      if g = @svg.at_css("svg g")
        #todo
      else
        svg = @svg.at_css("svg")
        children = svg.children
        transform ="<g transform=\""   + translate + scale+ "\"></g>"
        svg.prepend_child(transform)
        g=svg.at_css("g")
        children.each{ |node| node.parent=g   }
      end
    end

    def to_xml
      @svg.to_xml
    end

    private

    def transform_count
      transforms=[]
      counts=[]
      @transforms.sort.each do | trans|
        if transforms[-1] == trans
          counts[-1] += 1
        else
          transforms << trans
          counts << 1
        end
      end

      transforms[counts.index(counts.max)]
    end


    def get_translation_from_transform_translate(transformation)
      transformation.match(/translate\( ([-+]?\d+\.?\d*)\s*(,\s*([-+]?\d+\.?\d*))?\)/)
      translation =[$1.to_f,$1.to_f] if $1
      translation[1]=$3.to_f if $3
      tranlation||=nil
    end

    def get_matrix_from_transform_matrix(transform_matrix)
      transform_matrix.match(/matrix\(([-+]?\d+\.?\d*)\s*,\s*([-+]?\d+\.?\d*)\s*,([-+]?\d+\.?\d*)\s*,([-+]?\d+\.?\d*)\s*,([-+]?\d+\.?\d*)\s*,([-+]?\d+\.?\d*)\s*\)/)
       [$1.to_f, $2.to_f, $3.to_f, $4.to_f, $5.to_f, $6.to_f ]
    end

    def get_translation_from_matrix(matrix)
      # only valid if a,b,c,d = 1,0,0,1
      [matrix[4],matrix[5]]
    end

    def minmax(d=@d)
      d&&d.each do |xy|
        mini(xy)
        maxi(xy)
      end
    end

    def mini(new_value)
      x,y = *new_value
      x0,y0 = *@min
      @min=[ x <= (x0||x) && x || x0, y <= (y0||y) && y || y0]
    end

    def maxi(new_value)
      x,y = *new_value
      x0,y0 = *@max
      @max=[ x >= (x0||x) && x || x0, y >= (y0||y) && y || y0]
    end

    def splitxy_for_text(text)
      x,y,font=text["x"].to_f,text["y"].to_f,(text["font"].match(/(\d+\.?\d*)px/) && $1).to_f
      l=text.content.size
      [[x,y],[x+font*l,y+font]]
    end
    def splitxy_for_circle(circle)
      cx,cy,r=circle["cx"].to_f,circle["cy"].to_f,circle["r"].to_f
      [[cx-r,cy-r],[cx+r,cy+r]]
    end

    def splitxy_for_path(d="",origin=[0,0])
      splitted=[]
      d.match(/\s*([mlhvzMLHVZ])/) && (command,data=$1,$')
      while data!=""
        case command
        when "M"
          data.match(/([-+]?\d+\.?\d*)\s*,\s*([-+]?\d+\.?\d*)\s*/) && (origin,data = [$1.to_f,$2.to_f],$') && splitted<<origin
        when "m"
          data.match(/[-+]?(\d+\.?\d*)\s*,\s*([-+]?\d+\.?\d*)\s*/) && (origin,data = [origin[0]+$1.to_f,origin[1]+$2.to_f],$') && splitted<<origin
        when "L"
          data.match(/[-+]?(\d+\.?\d*)\s*,\s*([-+]?\d+\.?\d*)\s*/) &&  (origin,data = [$1.to_f,$2.to_f],$') && splitted<<origin
        when "l"
          data.match(/[-+]?(\d+\.?\d*)\s*,\s*([-+]?\d+\.?\d*)\s*/) && (origin,data = [origin[0]+$1.to_f,origin[1]+$2.to_f],$') && splitted<<origin
        when "H"
          data.match(/[-+]?(\d+\.?\d*)\s*,?\s*/) && (origin,data = [$1.to_f,origin[1]],$') && splitted<<origin
          data.match(/[-+]?(\d+\.?\d*)\s*,?\s*/) && (origin,data = [$1.to_f+origin[0],origin[1]],$') && splitted<<origin
        when "V"
          data.match(/[-+]?(\d+\.?\d*)\s*,?\s*/) && (origin,data = [origin[0],$1.to_f],$') && splitted<<origin
        when "v"
        when "h"
          data.match(/[-+]?(\d+\.?\d*)\s*,?\s*/) && (origin,data = [origin[0],$1.to_f+origin[1]],$') && splitted<<origin
        when "Z"
        when "z"
        #todo cubic bezier https://www.w3.org/TR/SVG/paths.html#PathData
        when "s"
        when "S"
        when "c"
        when "C"
        end
        data.match(/\s*([mlhvzscMLHVZSC])/) && (command,data=$1,$') || (data="")
      end
      splitted
    end

  end #class SVGProcessor
end #module KetcherRails
