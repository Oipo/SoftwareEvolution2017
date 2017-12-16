import { Component, ElementRef, OnDestroy, OnInit } from '@angular/core';

import * as d32 from 'd3';


import {
  D3Service,
  D3,
  Axis,
  BrushBehavior,
  BrushSelection,
  D3BrushEvent,
  ScaleLinear,
  ScaleOrdinal,
  Selection,
  Transition,
  ValueFn

} from 'd3-ng2-service';

class d3Datum {
  x: number;
  y: number;
}

@Component({
  selector: 'app-treemap',
  templateUrl: './treemap.component.html',
  styleUrls: ['./treemap.component.css']
})
export class TreemapComponent implements OnInit, OnDestroy {
  private d3: D3;
  private parentNativeElement: any;
  private d3Svg: Selection<SVGSVGElement, any, null, undefined>;

  constructor(element: ElementRef, d3Service: D3Service) {
    this.d3 = d3Service.getD3();
    this.parentNativeElement = element.nativeElement;
  }

  ngOnDestroy() {
    if (this.d3Svg.empty && !this.d3Svg.empty()) {
      this.d3Svg.selectAll('*').remove();
    }
  }

  ngOnInit() {
    var svg = this.d3.select("svg"),
    width = +svg.attr("width"),
    height = +svg.attr("height");
    var tempD3 = this.d3;

    var fader = function(color) { return tempD3.interpolateRgb(color, "#fff")(0.2); },
        color = this.d3.scaleOrdinal(this.d3.schemeCategory20.map(fader)),
        format = this.d3.format(",d");

    var treemap = this.d3.treemap()
        .tile(this.d3.treemapResquarify)
        .size([width, height])
        .round(true)
        .paddingInner(1);

    d32.json("clonesTreemap.json", function(error, data) {
      if (error) throw error;

      var root = tempD3.hierarchy(data)
          .eachBefore(function(d: any) { d.data.id = (d.parent ? d.parent.data.id + "." : "") + d.data.name; })
          .sum(sumBySize)
          .sort(function(a, b) { return b.height - a.height || b.value - a.value; });

      treemap(root);

      var cell = svg.selectAll("g")
        .data(root.leaves())
        .enter().append("g")
          .attr("transform", function(d: any) { return "translate(" + d.x0 + "," + d.y0 + ")"; });

      cell.append("rect")
          .attr("id", function(d: any) { return d.data.id; })
          .attr("width", function(d: any) { return d.x1 - d.x0; })
          .attr("height", function(d: any) { return d.y1 - d.y0; })
          .on("click", function(d: any) { window.open("http://localhost:4200/codeClones.html#" + d.data.cloneTag); })
          .attr("fill", function(d: any) { return color(d.parent.data.id); });

      cell.append("clipPath")
          .attr("id", function(d: any) { return "clip-" + d.data.id; })
        .append("use")
          .attr("xlink:href", function(d: any) { return "#" + d.data.id; });

      cell.append("text")
          .attr("clip-path", function(d: any) { return "url(#clip-" + d.data.id + ")"; })
        .selectAll("tspan")
          .data(function(d: any) { return d.data.name.split(/(?=[A-Z][^A-Z])/g); })
        .enter().append("tspan")
          .attr("x", 4)
          .attr("y", function(d, i) { return 13 + i * 10; })
          .text(function(d: any) { return d; });

      cell.append("title")
          .text(function(d: any) { return d.data.id + "\n" + format(d.value); });

          tempD3.selectAll("input")
          .data([sumBySize, sumByCount], function(d: any) { return d ? d.name : "this.value"; })
          .on("change", changed);

      var timeout = tempD3.timeout(function() {
        tempD3.select("input[value=\"sumByCount\"]")
            .property("checked", true)
            .dispatch("change");
      }, 2000);

      function changed(sum) {
        timeout.stop();

        treemap(root.sum(sum));

        cell.transition()
            .duration(750)
            .attr("transform", function(d: any) { return "translate(" + d.x0 + "," + d.y0 + ")"; })
          .select("rect")
            .attr("width", function(d: any) { return d.x1 - d.x0; })
            .attr("height", function(d: any) { return d.y1 - d.y0; });
      }
    });

    function sumByCount(d) {
      return d.children ? 0 : 1;
    }

    function sumBySize(d) {
      return d.size;
    }
  }
}
