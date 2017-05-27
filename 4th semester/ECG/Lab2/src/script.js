// Variables

var plot3d = { svg: SVG('3d') }, plot2d = { svg: SVG('2d') };
var plotBres = { svg: SVG('bresenham') };
var line3d = false, line2d = false;
var viewboxBase = 50;
var sin60 = Math.sin(Math.PI / 3);
var cos60 = Math.cos(Math.PI / 3);
var axis = ['x','y','z'];
var surf = ['xy','xz','yz'];
var ab = ['a','b'];
var r = 1.5;
//////////////////////////////////////////////////////////////////////////////

// Plotting 3D

function draw3dGrid(plot) {
    plot.g = plot.svg.group().scale(1,-1);
    axis.forEach(function(i) {
        plot[i] = {}
        plot[i].g = plot.g.group().addClass(i);
        plot[i].positive = plot[i].g.line(0,0,0,0).addClass('line');
        plot[i].negative = plot[i].g.line(0,0,0,0).addClass('line dashed');
        plot[i].arrow = plot[i].g.polygon('0,0,0,0,0,0').addClass('arrow');
        plot[i].text = plot.svg.plain(i).addClass('sub');
    });
    plot.x.g.rotate(120);
    plot.y.g.rotate(240);
    plot.g.rect(1,1).fill('black').attr({ x: -0.5, y: -0.5 });
}

function redraw3dGrid(plot, vb) {
    plot.svg.viewbox(-vb, -vb, vb*2, vb*2);
    axis.forEach(function(i) {
        plot[i].positive.attr({ x1: 0, y1: vb-2, x2: 0, y2: 0});
        plot[i].negative.attr({ x1: 0, y1: 0, x2: 0, y2: -vb});
        plot[i].arrow.attr({ points: `${0} ${vb}, 2 ${vb-4}, -2 ${vb-4}`});
    });
    plot.x.text.attr({ x: -(vb-4)*sin60, y: (vb-4)*cos60-4 });
    plot.y.text.attr({ x: (vb-4)*sin60,  y: (vb-4)*cos60-4 });
    plot.z.text.attr({ x: 2, y: -vb + 6 });
}

function calc3dCoords(c) {
    return {
        x: { x: -c.x*sin60, y: -c.x*cos60 },
        y: { x:  c.y*sin60, y: -c.y*cos60 },
        z: { x:  0,           y:  c.z }
    };
}

function drawPoint3d(plot) {
    var point = {};
    axis.forEach(function(i) {
        point[i] = {};
        point[i].line = plot.g.line(0,0,0,0).addClass('line thick pointed');
        point[i].lineax = plot.g.line(0,0,0,0).addClass('line thick pointed');
        point[i].point = plot.g.circle(r).addClass('point ' + i);
    });
    surf.forEach(function(i) {
        point[i] = {};
        point[i].line = plot.g.polyline('0 0, 0 0').addClass('line thick pointed');
        point[i].point = plot.g.circle(r).addClass('point ' + i);
    });
    axis.forEach(function(i) { point[i].point.front(); });
    point.point = plot.g.circle(r).addClass('point');
    return point;
}

function drawLine3d(plot) {
    var line = {};
    surf.forEach(function(i) {
        line[i] = plot.g.line(0,0,0,0).addClass('line dashed ' + i);
    });
    line.line = plot.g.line(0,0,0,0).addClass('line');
    line.a = drawPoint3d(plot);
    line.b = drawPoint3d(plot);
    return line;
}

function redrawPoint3d(point, c3d) {
    var c = calc3dCoords(c3d);
    var p = { x: c.x.x+c.y.x+c.z.x, y: c.x.y+c.y.y+c.z.y };
    axis.forEach(function(i) {
        point[i].point.attr({ cx: c[i].x, cy: c[i].y });
        point[i].line.attr({ x1: p.x-c[i].x, y1: p.y-c[i].y,
                             x2: p.x, y2: p.y });
        point[i].lineax.attr({x1: 0, y1: 0,
                              x2: c[i].x, y2: c[i].y });
    });
    surf.forEach(function(i) {
        var a = i[0], b = i[1];
        point[i].point.attr({ cx: c[a].x+c[b].x,  cy: c[a].y+c[b].y})
        point[i].line.plot(
            [[c[a].x, c[a].y], [c[a].x+c[b].x, c[a].y+c[b].y], [c[b].x, c[b].y]]);
    });
    point.point.attr( { cx: p.x, cy: p.y });
}

function redrawLine3d(line, c3d) {
    var ac = calc3dCoords(c3d.a);
    var bc = calc3dCoords(c3d.b);
    line.line.attr({x1: ac.x.x+ac.y.x+ac.z.x, y1: ac.x.y+ac.y.y+ac.z.y,
                    x2: bc.x.x+bc.y.x+bc.z.x, y2: bc.x.y+bc.y.y+bc.z.y});
    surf.forEach(function(i) {
        var a = i[0], b = i[1];
        line[i].attr({ x1: ac[a].x + ac[b].x, y1: ac[a].y + ac[b].y,
                       x2: bc[a].x + bc[b].x, y2: bc[a].y + bc[b].y });
    });
    redrawPoint3d(line.a, c3d.a);
    redrawPoint3d(line.b, c3d.b);
}

function getOct(c) {
    if (c.x >= 0 && c.y >= 0 && c.z >= 0) {
        return 1;
    }
    else if (c.x >= 0 && c.y < 0 && c.z >= 0) {
        return 2;
    }
    else if (c.x >= 0 && c.y < 0 && c.z < 0) {
        return 3;
    }
    else if (c.x >= 0 && c.y >= 0 && c.z < 0) {
        return 4;
    }
    else if (c.x < 0 && c.y >= 0 && c.z >= 0) {
        return 5;
    }
    else if (c.x < 0 && c.y < 0 && c.z >= 0) {
        return 6;
    }
    else if (c.x < 0 && c.y < 0 && c.z < 0) {
        return 7;
    }
    else if (c.x < 0 && c.y >= 0 && c.z < 0) {
        return 8;
    }
}

draw3dGrid(plot3d);
redraw3dGrid(plot3d, viewboxBase);
//////////////////////////////////////////////////////////////////////////////

// Plotting 2D

function draw2dGrid(plot) {
    plot.g = plot.svg.group().scale(1, -1);
    plot.xa = plot.g.line(0,0,0,0).addClass('line');
    plot.ya = plot.g.line(0,0,0,0).addClass('line');
    plot.text = {};
    ['x','z','yh','yv'].forEach(function(i,n) {
        plot.text[i] = plot.svg.plain(i[0]).addClass('sub');
        plot.text['-' + i] = plot.svg.plain('-' + i[0]).addClass('sub');
    });
}

function redraw2dGrid(plot, vb) {
    plot.svg.viewbox(-vb,-vb,vb*2,vb*2);
    plot.xa.attr({ x1: -vb, y1: 0, x2: vb, y2: 0 });
    plot.ya.attr({ x1: 0, y1: -vb, x2: 0, y2: vb});
    plot.text['x'].attr({ x: -vb+3.4, y: -2 });
    plot.text['yh'].attr({ x: vb-3, y: -2 });
    plot.text['yv'].attr({ x: -3.5, y: vb-5 });
    plot.text['z'].attr({ x: -3.5, y: -vb+5 });
    plot.text['-x'].attr({ x: vb-4.6, y: 4 });
    plot.text['-yh'].attr({ x: -vb+1.3, y: 4});
    plot.text['-yv'].attr({x: 1.5, y: -vb+5});
    plot.text['-z'].attr({x: 1.5, y: vb-5 });
}

function getTransform(s, plot) {
    switch (s) {
            case 'xy':
                return plot.g.group().scale(-1, -1);
            case 'xz':
                return plot.g.group().scale(-1, 1);
            default:
                return plot.g.group();
        }
}

function drawPoint2d(plot) {
    var point = {};
    point.arc = plot.g.path().addClass('line thick y');
    surf.forEach(function(i) {
        point[i] = {};
        switch (i) {
            case 'xy':
                point[i].gp = plot.g.group().scale(-1, -1);break;
            case 'xz':
                point[i].gp = plot.g.group().scale(-1, 1);break;
            default:
                point[i].gp = plot.g.group();break;
        }
        point[i].gl = point[i].gp.clone();
        var a=i[0], b=i[1];
        point[i][a] = point[i].gl.line().addClass('line thick pointed ' + a);
        point[i][b] = point[i].gl.line().addClass('line thick pointed ' + b);
        point[i].point = point[i].gp.circle(r).addClass('point ' + i);
    });
    surf.forEach(function(i) {
        point[i].gp.front();
    });
    return point;
}

function drawLine2d(plot) {
    var line = {};
    surf.forEach(function(i) {
        line[i] = {};
        line[i].g = getTransform(i, plot);
        line[i].line = line[i].g.line(0,0,0,0).addClass('line ' + i);
    });
    line.a = drawPoint2d(plot);
    line.b = drawPoint2d(plot);
    return line;
}

function redrawPoint2d(point, c) {
    surf.forEach(function(i) {
        var a=i[0], b=i[1];
        point[i].point.attr({cx: c[a], cy: c[b] });
        point[i][a].attr({x1: c[a], y1: c[b], x2: c[a], y2: 0 });
        point[i][b].attr({x1: c[a], y1: c[b], x2: 0, y2: c[b] });
    });
    point.arc.attr({ d: `M ${c.y} 0 A ${c.y} ${c.y} 0 0 0 0 ${-c.y}`})
}

function redrawLine2d(line, c) {
    surf.forEach(function(i) {
        var x=i[0], y=i[1];
        line[i].line.attr({x1: c.a[x], y1: c.a[y], x2: c.b[x], y2: c.b[y]});
    });
    redrawPoint2d(line.a, c.a);
    redrawPoint2d(line.b, c.b);
}

draw2dGrid(plot2d);
redraw2dGrid(plot2d, viewboxBase);
//////////////////////////////////////////////////////////////////////////////

// Bresenham
function drawBresenhamGrid(plot) {
  var xs = 101;
  var ys = 51;
  plot.svg.viewbox(0, 0, xs, ys);
  for (var x = 1; x < xs; x++) {
    plot.svg.line(x, 0, x, ys).addClass('line verythick');
  }
  for (var y = 1; y < ys; y++) {
    plot.svg.line(0, y, xs, y).addClass('line verythick');
  }
  plot.g = plot.svg.group();
}

function drawPixel(g, c) {
  g.rect(1,1).attr({ x: c.x, y: c.y }).fill('blue');
}

function drawLineBresenham(plot, c1, c2) {
    plot.g.remove();
    plot.g = plot.svg.group();
    var d = {}
    d.x = Math.abs(c2.x - c1.x);
    d.y = Math.abs(c2.y - c1.y);
    var a,b;
    if (d.x >= d.y) { a='x'; b='y'; }
    else { a='y'; b='x'; }
    var s = c2[a] > c1[a] ? c1 : c2;
    var e = c2[a] > c1[a] ? c2 : c1;
    var step = s[b] > e[b] ? -1 : 1;
    var err = 0;
    var derr = d[b];
    var c = {};
    c[b] = s[b];
    for (c[a] = s[a]; c[a] <= e[a]; c[a]++) {
      drawPixel(plot.g, c);
      err += derr;
      if (2 * err >= d[a]) {
        c[b] += step;
        err -= d[a];
      }
    }
}

drawBresenhamGrid(plotBres);

//////////////////////////////////////////////////////////////////////////////

// Interface

function drawLegend() {
    axis.forEach(function(i) {
        SVG(i + '-line')
            .size(50, 20)
            .line(0,10,50,10)
            .attr({style: "stroke-width: 1;"})
            .addClass('line ' + i);
        SVG(i + '-point')
            .size(20,20)
            .viewbox(-2,-2,4,4)
            .circle(r)
            .attr({cx: 0, cy: 0})
            .addClass('point ' + i);
    });
    surf.forEach(function(i) {
      SVG(i + '-line')
          .size(50, 20)
          .line(0,10,50,10)
          .attr({style: "stroke-width: 1;"})
          .addClass('line ' + i);
        SVG(i + '-point')
            .size(20,20)
            .viewbox(-2,-2,4,4)
            .circle(r)
            .attr({cx: 0, cy: 0})
            .addClass('point ' + i);
    });
}

drawLegend();

function oninput(event) {
    if (!line3d) {
        line3d = drawLine3d(plot3d);
    }
    if (!line2d) {
        line2d = drawLine2d(plot2d);
    }
    var c = getCoords();
    var a = event.target.id[0];
    var b = event.target.id[1];
    document.getElementById(a + b + '-val').innerText = c[a][b];
    redrawLine3d(line3d, c);
    redrawLine2d(line2d, c);
}

function getCoords() {
    var c = {};
    ab.forEach(function(i) {
        c[i] = {}
        axis.forEach(function(j) {
            var input = document.getElementById(i + j + '-range');
            c[i][j] = input.value*1;
        });
    });
    return c;
}

ab.forEach(function(i) {
    axis.forEach(function(j) {
        var input = document.getElementById(i + j + '-range');
        input.oninput = oninput;
    });
});

document.getElementById('scaler').oninput = function() {
    redraw3dGrid(plot3d, scaler.value * viewboxBase);
    redraw2dGrid(plot2d, scaler.value * viewboxBase);
};


function oninputBres(event) {
  var c = getCoordBres();
  ab.forEach(function(i) {
      ['x', 'y'].forEach(function(j) {
          var val = document.getElementById('bres-' + i + j + '-val');
          val.innerText = c[i][j];
      });
  });
  drawLineBresenham(plotBres, c.a, c.b);
}

function getCoordBres() {
    var c = {};
    ab.forEach(function(i) {
        c[i] = {};
        ['x', 'y'].forEach(function(j) {
            var input = document.getElementById('bres-' + i + j + '-range');
            c[i][j] = input.value*1;
        });
    });
    return c;
}

ab.forEach(function(i) {
    ['x', 'y'].forEach(function(j) {
        var input = document.getElementById('bres-' + i + j + '-range');
        input.oninput = oninputBres;
    });
});
