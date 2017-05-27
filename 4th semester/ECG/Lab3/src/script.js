// Variables
var plot3d = { svg: SVG('3d') }, plot2d = { svg: SVG('2d') };
var line3d = false, line2d = false;
var plane3d = false, plane2d = false;
var viewboxBase = 50;
var sin60 = Math.sin(Math.PI / 3);
var cos60 = Math.cos(Math.PI / 3);
var axis = ['x','y','z'];
var surf = ['xy','xz','yz'];
var shortsurf = ['xy', 'xz'];
var ab = ['a','b'];
var abc = ['a','b','c'];
var r = 1.5;
//////////////////////////////////////////////////////////////////////////////

// Math

function calc3dCoords(c) {
    return {
        x: { x: -c.x*sin60, y: -c.x*cos60 },
        y: { x:  c.y*sin60, y: -c.y*cos60 },
        z: { x:  0,           y:  c.z }
    };
}

function calcPlaneEq(c) {
    var eq = {
        a: (c.a.y-c.b.y)*(c.a.z+c.b.z)
            + (c.b.y-c.c.y)*(c.b.z+c.c.z)
            + (c.c.y-c.a.y)*(c.c.z+c.a.z),
        b: (c.a.z-c.b.z)*(c.a.x+c.b.x)
            + (c.b.z-c.c.z)*(c.b.x+c.c.x)
            + (c.c.z-c.a.z)*(c.c.x+c.a.x),
        c: (c.a.x-c.b.x)*(c.a.y+c.b.y)
            + (c.b.x-c.c.x)*(c.b.y+c.c.y)
            + (c.c.x-c.a.x)*(c.c.y+c.a.y),
    };
    eq.d = -(eq.a*c.a.x+eq.b*c.a.y+eq.c*c.a.z);
    return eq;
}

function calcLineEq(c) {
    return {
        x: { s: c.a.x, d: c.b.x-c.a.x },
        y: { s: c.a.y, d: c.b.y-c.a.y },
        z: { s: c.a.z, d: c.b.z-c.a.z }
    };
}

function calcIntersect(p, l) {
    var b = p.a*l.x.d+p.b*l.y.d+p.c*l.z.d;
    if (b == 0) { return false; }
    var t = -(p.a*l.x.s+p.b*l.y.s+p.c*l.z.s+p.d)
            /b;
    return t > 1 || t < 0 ? false :
            {x: l.x.s + l.x.d*t,
            y: l.y.s + l.y.d*t,
            z: l.z.s + l.z.d*t};
}

function calcVisibility(p, c) {
    return (p.a*c.x + p.b*c.y + p.c*c.z + p.d)
            * (с < 0 ? -1 : 1);
}

function calcLineCoords(ac,bc) {
    return {x1: ac.x.x+ac.y.x+ac.z.x, y1: ac.x.y+ac.y.y+ac.z.y,
            x2: bc.x.x+bc.y.x+bc.z.x, y2: bc.x.y+bc.y.y+bc.z.y};
}
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

function hidePoint3d(point) {
    axis.forEach(function(i) {
        point[i].line.hide();
        point[i].lineax.hide();
        point[i].point.hide();
    });
    surf.forEach(function(i) {
        point[i].line.hide();
        point[i].point.hide();
    });
    point.point.hide();
}

function showPoint3d(point) {
    axis.forEach(function(i) {
        point[i].line.show();
        point[i].lineax.show();
        point[i].point.show();
    });
    surf.forEach(function(i) {
        point[i].line.show();
        point[i].point.show();
    });
    point.point.show();
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

function drawLine3dIntersect(plot) {
    var line = {};
    surf.forEach(function(i) {
        line[i] = plot.g.line(0,0,0,0).addClass('line dashed ' + i);
    });
    line.linev = plot.g.line(0,0,0,0).addClass('line');
    line.linei = plot.g.line(0,0,0,0).addClass('line dashed');
    line.a = drawPoint3d(plot);
    line.b = drawPoint3d(plot);
    line.int = drawPoint3d(plot);
    line.int.point.addClass('intersect');
    return line;
}

function drawPlane3d(plot) {
    var plane = {}
    plane.plane = plot.g.polygon("0 0, 0 0, 0 0").addClass('plane');
    plane.a = drawPoint3d(plot);
    plane.b = drawPoint3d(plot);
    plane.c = drawPoint3d(plot);
    return plane;
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
    line.line.attr(calcLineCoords(ac,bc));
    surf.forEach(function(i) {
        var a = i[0], b = i[1];
        line[i].attr({ x1: ac[a].x + ac[b].x, y1: ac[a].y + ac[b].y,
                       x2: bc[a].x + bc[b].x, y2: bc[a].y + bc[b].y });
    });
    redrawPoint3d(line.a, c3d.a);
    redrawPoint3d(line.b, c3d.b);
}

function redrawLine3dIntersect(line, c3d, peq) {
    var leq = calcLineEq(c3d);
    var cint = calcIntersect(peq,leq);
    var ac = calc3dCoords(c3d.a);
    var bc = calc3dCoords(c3d.b);
    if (cint) {
        showPoint3d(line.int);
        redrawPoint3d(line.int, cint);
        var ic = calc3dCoords(cint);
        var avis = calcVisibility(peq, c3d.a);
        var bvis = calcVisibility(peq, c3d.b);
        var svc = false, sic = false;
        if (avis >= 0 && bvis >= 0) {
            svc = avis > bvis ? ac : bc;
        }
        else if (avis <= 0 && bvis <= 0) {
            sic = avis > bvis ? bc : ac;
        }
        else {
            svc = avis > 0 ? ac : bc;
            sic = avis < 0 ? ac : bc;
        }
        if (svc) {
            line.linev.show();
            line.linev.attr(calcLineCoords(svc,ic));
        } else { line.linev.hide(); }
        if (sic) {
            line.linei.show();
            line.linei.attr(calcLineCoords(sic,ic));
        } else { line.linei.hide(); }
    }
    else {
        hidePoint3d(line.int);
        var avis = calcVisibility(peq, c3d.a);
        if (avis >= 0) {
            line.linev.show();
            line.linei.hide();
            line.linev.attr(calcLineCoords(ac,bc));
        }
        else {
            line.linei.show();
            line.linev.hide();
            line.linei.attr(calcLineCoords(ac,bc));
        }
    }
    surf.forEach(function(i) {
        var a = i[0], b = i[1];
        line[i].attr({ x1: ac[a].x + ac[b].x, y1: ac[a].y + ac[b].y,
                       x2: bc[a].x + bc[b].x, y2: bc[a].y + bc[b].y });
    });
    redrawPoint3d(line.a, c3d.a);
    redrawPoint3d(line.b, c3d.b);
}

function redrawPlane3d(plane, c3d) {
    var c = {};
    var points = [];
    abc.forEach(function(i) {
        redrawPoint3d(plane[i], c3d[i]);
        c[i] = calc3dCoords(c3d[i]);
        points.push(`${c[i].x.x+c[i].y.x+c[i].z.x} `
                    + `${c[i].x.y+c[i].y.y+c[i].z.y}`);
    });
    plane.plane.attr({ points: points.join(',') });
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
    ['x','z','yv'].forEach(function(i,n) {
        plot.text[i] = plot.svg.plain(i[0]).addClass('sub');
        plot.text['-' + i] = plot.svg.plain('-' + i[0]).addClass('sub');
    });
}

function redraw2dGrid(plot, vb) {
    plot.svg.viewbox(-vb,-vb,vb*2,vb*2);
    plot.xa.attr({ x1: -vb, y1: 0, x2: vb, y2: 0 });
    plot.ya.attr({ x1: 0, y1: -vb, x2: 0, y2: vb});
    plot.text['x'].attr({ x: -vb+3.4, y: -2 });
    //plot.text['yh'].attr({ x: vb-3, y: -2 });
    plot.text['yv'].attr({ x: -3.5, y: vb-5 });
    plot.text['z'].attr({ x: -3.5, y: -vb+5 });
    plot.text['-x'].attr({ x: vb-4.6, y: 4 });
    //plot.text['-yh'].attr({ x: -vb+1.3, y: 4});
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
    point.arc = plot.g.path().addClass('line thick pointed y');
    shortsurf.forEach(function(i) {
        point[i] = {};
        point[i].gp = getTransform(i, plot);
        point[i].gl = point[i].gp.clone();
        var a=i[0], b=i[1];
        point[i][a] = point[i].gl.line().addClass('line thick pointed ' + a);
        point[i][b] = point[i].gl.line().addClass('line thick pointed ' + b);
        point[i].point = point[i].gp.circle(r).addClass('point ' + i);
    });
    shortsurf.forEach(function(i) {
        point[i].gp.front();
    });
    return point;
}

function hidePoint2d(point) {
    point.arc.hide();
    shortsurf.forEach(function(i) {
        point[i].gp.hide();
        point[i].gl.hide();
    });
}

function showPoint2d(point) {
    point.arc.show();
    shortsurf.forEach(function(i) {
        point[i].gp.show();
        point[i].gl.show();
    });
}

function drawLine2d(plot) {
    var line = {};
    shortsurf.forEach(function(i) {
        line[i] = {};
        line[i].g = getTransform(i, plot);
        line[i].line = line[i].g.line(0,0,0,0).addClass('line ' + i);
    });
    line.a = drawPoint2d(plot);
    line.b = drawPoint2d(plot);
    return line;
}

function drawLine2dIntersect(plot) {
    var line = {};
    shortsurf.forEach(function(i) {
        line[i] = {};
        line[i].g = getTransform(i, plot);
        line[i].line = line[i].g.line(0,0,0,0).addClass('line ' + i);
        line[i].linei = line[i].g.line(0,0,0,0).addClass('line ' + i);
    });
    line.a = drawPoint2d(plot);
    line.b = drawPoint2d(plot);
    line.int = drawPoint2d(plot);
    shortsurf.forEach(function(i) {
        line.int[i].point.addClass('intersect');
    });
    return line;
}

function drawPlane2d(plot) {
    var plane = {};
    shortsurf.forEach(function(i) {
        plane[i] = {};
        plane[i].g = getTransform(i,plot);
        plane[i].plane =
            plane[i].g.polygon("0 0, 0 0, 0 0")
                        .addClass('plane ' + i);
    });
    plane.a = drawPoint2d(plot);
    plane.b = drawPoint2d(plot);
    plane.c = drawPoint2d(plot);
    return plane;
}

function redrawPoint2d(point, c) {
    shortsurf.forEach(function(i) {
        var a=i[0], b=i[1];
        point[i].point.attr({cx: c[a], cy: c[b] });
        point[i][a].attr({x1: c[a], y1: c[b], x2: c[a], y2: 0 });
        point[i][b].attr({x1: c[a], y1: c[b], x2: 0, y2: c[b] });
    });
    point.arc.attr({ d: `M ${c.y} 0 A ${c.y} ${c.y} 0 0 0 0 ${-c.y}`})
}

function redrawLine2d(line, c) {
    shortsurf.forEach(function(i) {
        var x=i[0], y=i[1];
        line[i].line.attr({x1: c.a[x], y1: c.a[y], x2: c.b[x], y2: c.b[y]});
    });
    redrawPoint2d(line.a, c.a);
    redrawPoint2d(line.b, c.b);
}

function redrawLine2dIntersect(line, c, peq) {
    var leq = calcLineEq(c);
    var cint = calcIntersect(peq, leq);
    if (cint) {
        shortsurf.forEach(function(i) {
            var x=i[0], y=i[1];
            line[i].line.attr({x1: c.a[x], y1: c.a[y],
                               x2: c.b[x], y2: c.b[y]});
            line[i].linei.attr({x1: c.a[x], y1: c.a[y],
                                x2: cint[x], y2: cint[y]});
        });
        showPoint2d(line.int);
        redrawPoint2d(line.int, cint);
    }
    else {
        shortsurf.forEach(function(i) {
            var x=i[0], y=i[1];
            line[i].line.attr({x1: c.a[x], y1: c.a[y], x2: c.b[x], y2: c.b[y]});
        });
        hidePoint2d(line.int);
    }
    redrawPoint2d(line.a, c.a);
    redrawPoint2d(line.b, c.b);
}

function redrawPlane2d(plane, c) {
    shortsurf.forEach(function(i) {
        var x=i[0], y = i[1];
        plane[i].plane.attr({
            points: `${c.a[x]} ${c.a[y]},
                     ${c.b[x]} ${c.b[y]},
                     ${c.c[x]} ${c.c[y]}`
        });
    });
    redrawPoint2d(plane.a, c.a);
    redrawPoint2d(plane.b, c.b);
    redrawPoint2d(plane.c, c.c);
}

draw2dGrid(plot2d);
redraw2dGrid(plot2d, viewboxBase);
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
    SVG('intersect-point')
      .size(20,20)
      .viewbox(-2,-2,4,4)
      .circle(r)
      .attr({cx: 0, cy: 0})
      .addClass('point intersect');
}

drawLegend();

function oninputLine(event) {
    if (!line3d) {
        line3d = drawLine3dIntersect(plot3d);
    }
    if (!line2d) {
        line2d = drawLine2dIntersect(plot2d);
    }
    var cl = getCoordsLine();
    var cp = getCoordsPlane();
    var a = event.target.id[0];
    var b = event.target.id[1];
    document.getElementById(a + b + '-val').innerText = cl[a][b];
    var peq = calcPlaneEq(cp);
    redrawLine3dIntersect(line3d, cl, peq);
    redrawLine2dIntersect(line2d, cl, peq);
}

function oninputPlane(event) {
    if (!plane3d) {
        plane3d = drawPlane3d(plot3d);
    }
    if (!plane2d) {
        plane2d = drawPlane2d(plot2d);
    }
    var cp = getCoordsPlane();
    var a = event.target.id[0];
    var b = event.target.id[1];
    document.getElementById(a + b + '-plane-val').innerText = cp[a][b];
    redrawPlane3d(plane3d, cp);
    redrawPlane2d(plane2d, cp);
    if (line3d) {
        var cl = getCoordsLine();
        var peq = calcPlaneEq(cp);
        redrawLine3dIntersect(line3d, cl, peq);
        redrawLine2dIntersect(line2d, cl, peq);
    }
}

function getCoordsLine() {
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

function getCoordsPlane() {
    var c = {};
    abc.forEach(function(i) {
        c[i] = {}
        axis.forEach(function(j) {
            var input = document.getElementById(i + j + '-plane-range');
            c[i][j] = input.value*1;
        });
    });
    return c;
}

ab.forEach(function(i) {
    axis.forEach(function(j) {
        var input = document.getElementById(i + j + '-range');
        input.oninput = oninputLine;
    });
});

abc.forEach(function(i) {
    axis.forEach(function(j) {
        var input = document.getElementById(i + j + '-plane-range');
        input.oninput = oninputPlane;
    });
})

document.getElementById('scaler').oninput = function() {
    redraw3dGrid(plot3d, scaler.value * viewboxBase);
    redraw2dGrid(plot2d, scaler.value * viewboxBase);
};
