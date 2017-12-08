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
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'app';

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
    var diameter = 960,
    radius = diameter / 2,
    innerRadius = radius - 120;

    var cluster = this.d3.cluster()
        .size([360, innerRadius]);

    var line = this.d3.radialLine()
        .curve(this.d3.curveBundle.beta(0.85))
        .radius(function(d: any) { return d.y; })
        .angle(function(d: any) { return d.x / 180 * Math.PI; });

    var svg = this.d3.select("body").append("svg")
        .attr("width", diameter)
        .attr("height", diameter)
      .append("g")
        .attr("transform", "translate(" + radius + "," + radius + ")");

    var link = svg.append("g").selectAll(".link"),
        node = svg.append("g").selectAll(".node");

        var tempD3 = this.d3;

        d32.json("flare.json", function(error, classes) {
      if (error) throw error;

      var root = packageHierarchy(classes, tempD3)
          .sum(function(d) { return d.size; });

      cluster(root);

      link = link
        .data(packageImports(root.leaves()))
        .enter().append("path")
          .each(function(d) { d.source = d[0], d.target = d[d.length - 1]; })
          .attr("class", "link")
          .attr("d", line);

      node = node
        .data(root.leaves())
        .enter().append("text")
          .attr("class", "node")
          .attr("dy", "0.31em")
          .attr("transform", function(d: any) { return "rotate(" + (d.x - 90) + ")translate(" + (d.y + 8) + ",0)" + (d.x < 180 ? "" : "rotate(180)"); })
          .attr("text-anchor", function(d: any) { return d.x < 180 ? "start" : "end"; })
          .text(function(d: any) { return d.data.key; })
          .on("mouseover", mouseovered)
          .on("mouseout", mouseouted);
    });

    function mouseovered(d) {
      node
          .each(function(n: any) { n.target = n.source = false; });

      link
          .classed("link--target", function(l: any) { if (l.target === d) return l.source.source = true; })
          .classed("link--source", function(l: any) { if (l.source === d) return l.target.target = true; })
        .filter(function(l: any) { return l.target === d || l.source === d; })
          .raise();

      node
          .classed("node--target", function(n: any) { return n.target; })
          .classed("node--source", function(n: any) { return n.source; });
    }

    function mouseouted(d) {
      link
          .classed("link--target", false)
          .classed("link--source", false);

      node
          .classed("node--target", false)
          .classed("node--source", false);
    }

    // Lazily construct the package hierarchy from class names.
    function packageHierarchy(classes, d3: D3) {
      var map = {};

      function find(name, data) {
        var node = map[name], i;
        if (!node) {
          node = map[name] = data || {name: name, children: []};
          if (name.length) {
            node.parent = find(name.substring(0, i = name.lastIndexOf(".")), null);
            node.parent.children.push(node);
            node.key = name.substring(i + 1);
          }
        }
        return node;
      }

      classes.forEach(function(d) {
        find(d.name, d);
      });

      return d3.hierarchy(map[""]);
    }

    // Return a list of imports for the given array of nodes.
    function packageImports(nodes) {
      var map = {},
          imports = [];

      // Compute a map from name to node.
      nodes.forEach(function(d) {
        map[d.data.name] = d;
      });

      // For each import, construct a link from the source to target node.
      nodes.forEach(function(d) {
        if (d.data.imports) d.data.imports.forEach(function(i) {
          imports.push(map[d.data.name].path(map[i]));
        });
      });

      return imports;
    }
  }
  
}
