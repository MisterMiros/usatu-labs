// Variables
var plot3d = { svg: SVG('3d') }, plotPOV = { svg: SVG('POV') };
var line3d = false, linePOV = false;
var cube3d = false, cubePOV = false;
var observePoint3d = false;
var viewboxBase = 50;
var sin60 = Math.sin(Math.PI / 3);
var cos60 = Math.cos(Math.PI / 3);
var axis = ['x','y','z'];
var surf = ['xy','xz','yz'];
var shortsurf = ['xy', 'xz'];
var ab = ['a','b'];
var abc = ['a','b','c'];
var r = 1.5;
var csize = 15;
var cc = { x: 0.0, y: 0.0, z: 0.0 };
var scaler = document.getElementById('scaler');
var move = document.getElementById('move');
var rotate = document.getElementById('rotate');
var observe = document.getElementById('observe');
// Helpers

function drawCube(plot) {
    var cube = {};
    cube.vertexes = {};
    cube.edges = {};
    axis.forEach(function(i) {
        cube.edges[i] = {};
    });
    ['x','-x'].forEach(function(i) {
        ['y','-y'].forEach(function(j) {
            ['z','-z'].forEach(function(k) {
                if (i=='x') {
                    cube.edges[i][j+k] = plot.g.line(0,0,0,0).addClass('line');
                }
                if (j=='y') {
                    cube.edges[j][i+k] = plot.g.line(0,0,0,0).addClass('line');
                }
                if (k=='z') {
                    cube.edges[k][i+j] = plot.g.line(0,0,0,0).addClass('line');
                }
                cube.vertexes[i+j+k] = plot.g.circle(r).addClass('point');
            });
        });
    });
    //cube.center = drawPoint3d(plot);
    return cube;
}

function redrawCube(cube, matr, op, pov) {
    if (pov) {
        var calcCoords = function(c) {
            return calcPersp(c, op);
        }
        var calcEdge = function(a,b) {
            return {x1: a.x, y1: a.y,
                    x2: b.x, y2: b.y};
        }
        var calcVertex = function(c) {
            return { cx: c.x, cy: c.y };
        }
    } else {
         var calcCoords = calc3dCoords;
         var calcEdge = calcLineCoords;
         var calcVertex = function(c) {
             return { cx: c.x.x + c.y.x + c.z.x ,
                     cy: c.x.y + c.y.y + c.z.y };
         }
     }
    var c = calcVertexesCoords(matr);
    var centc = moveRotate(cc, matr);
    //redrawPoint3d(cube.center, centc);
    var faces = {};
    faces['x'] = multPeqObs(changeSign(calcPlaneEq(
        c['xyz'],c['x-yz'],c['xy-z']),centc),op);
    faces['-x'] = multPeqObs(changeSign(calcPlaneEq(
        c['-xyz'],c['-x-yz'],c['-xy-z']),centc),op);
    faces['y'] = multPeqObs(changeSign(calcPlaneEq(
        c['xyz'],c['-xyz'],c['xy-z']),centc),op);
    faces['-y'] = multPeqObs(changeSign(calcPlaneEq(
        c['x-yz'],c['-x-yz'],c['x-y-z']),centc),op);
    faces['z'] = multPeqObs(changeSign(calcPlaneEq(
        c['xyz'],c['x-yz'],c['-xyz']),centc),op);
    faces['-z'] = multPeqObs(changeSign(calcPlaneEq(
        c['xy-z'],c['x-y-z'],c['-xy-z']),centc),op);
    ['x','-x'].forEach(function(i) {
        ['y','-y'].forEach(function(j) {
            ['z','-z'].forEach(function(k) {
                var c2d =
                    calcCoords(c[i+j+k]);
                cube.vertexes[i+j+k]
                    .attr(calcVertex(c2d));

                if (i == 'x') {
                    var cn = calcCoords(c['-x' + j + k]);
                    var edge = cube.edges[i][j+k];
                    edge.attr(calcEdge(c2d,cn));
                    if (faces[j] <= 0 && faces[k] <= 0) {
                        edge.addClass('dashed');
                    }
                    else {
                        edge.removeClass('dashed');
                    }
                }
                if (j == 'y') {
                    var cn = calcCoords(c[i + '-y' + k]);
                    var edge = cube.edges[j][i+k];
                    edge.attr(calcEdge(c2d,cn));
                    if (faces[i] <= 0 && faces[k] <= 0) {
                        edge.addClass('dashed');
                    }
                    else {
                        edge.removeClass('dashed');
                    }
                }
                if (k == 'z') {
                    var cn = calcCoords(c[i + j + '-z']);
                    var edge = cube.edges[k][i+j];
                    edge.attr(calcEdge(c2d,cn));
                    if (faces[i] <= 0 && faces[j] <= 0) {
                        edge.addClass('dashed');
                    }
                    else {
                        edge.removeClass('dashed');
                    }
                }
            });
        });
    });
}

// Math

function calcLineCoords(ac,bc) {
    return {x1: ac.x.x+ac.y.x+ac.z.x, y1: ac.x.y+ac.y.y+ac.z.y,
            x2: bc.x.x+bc.y.x+bc.z.x, y2: bc.x.y+bc.y.y+bc.z.y};
}

function calcPlaneEq(c1,c2,c3) {
    var eq = {
        a: (c1.y-c2.y)*(c1.z+c2.z)
            + (c2.y-c3.y)*(c2.z+c3.z)
            + (c3.y-c1.y)*(c3.z+c1.z),
        b: (c1.z-c2.z)*(c1.x+c2.x)
            + (c2.z-c3.z)*(c2.x+c3.x)
            + (c3.z-c1.z)*(c3.x+c1.x),
        c: (c1.x-c2.x)*(c1.y+c2.y)
            + (c2.x-c3.x)*(c2.y+c3.y)
            + (c3.x-c1.x)*(c3.y+c1.y),
    };
    eq.d = -(eq.a*c1.x+eq.b*c1.y+eq.c*c1.z);
    return eq;
}

function multPeqObs(peq, c) {
    return c.x*peq.a+c.y*peq.b+c.z*peq.c;
}

function changeSign(peq, c) {
    var t = multPeqObs(peq, c)+peq.d;
    if (t > 0) {
        return {
            a: -peq.a,
            b: -peq.b,
            c: -peq.c,
            d: -peq.d
        }
    }
    return peq;
}

function calcLineEq(c) {
    return {
        x: { s: c.a.x, d: c.b.x-c.a.x },
        y: { s: c.a.y, d: c.b.y-c.a.y },
        z: { s: c.a.z, d: c.b.z-c.a.z }
    };
}

function calcDirection(c) {
    var dx = c.b.x - c.a.x;
    var dy = c.b.y - c.a.y;
    var dz = c.b.z - c.a.z;
    var l = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2) +Math.pow(dz,2));
    return {
        x: dx / l,
        y: dy / l,
        z: dz / l
    }
}

function calcMatrix(cl, m, r) {
    var dir = calcDirection(cl);
    r = r % 360;
    if (r != 0) {
        var res = math.matrix([[1,0,0,cl.a.x],
                [0,1,0,cl.a.y],
                [0,0,1,cl.a.z],
                [0,0,0,1]]);
        if (!(dir.y == 0 && dir.z == 0)) {
            var cosy = dir.z/Math.sqrt(Math.pow(dir.y,2)+Math.pow(dir.z,2));
            var siny = dir.y/Math.sqrt(Math.pow(dir.y,2)+Math.pow(dir.z,2));
            var a6 = math.matrix([[1,0,0,0],
                    [0,cosy,siny,0],
                    [0,-siny,cosy,0],
                    [0,0,0,1]]);
            res = math.multiply(res,a6);
        }
        if (dir.x != 0) {
            var cost = Math.sqrt(Math.pow(dir.y,2)+Math.pow(dir.z,2));
            var sint = dir.x;
            var a5 = math.matrix([[cost,0,sint,0],
                    [0,1,0,0],
                    [-sint,0,cost,0],
                    [0,0,0,1]]);
            res = math.multiply(res,a5);
        }
        var cosf = Math.cos(r*Math.PI/180);
        var sinf = Math.sin(r*Math.PI/180);
        var a4 = math.matrix([[cosf,-sinf,0,0],
                [sinf,cosf,0,0],
                [0,0,1,0],
                [0,0,0,1]]);
        res = math.multiply(res,a4);
        if (dir.x != 0) {
            var a3 = math.matrix([[cost,0,-sint,0],
                    [0,1,0,0],
                    [sint,0,cost,0],
                    [0,0,0,1]]);
            res = math.multiply(res,a3);
        }
        if (!(dir.y == 0 && dir.z == 0)) {
            var a2 = math.matrix([[1,0,0,0],
                    [0,cosy,-siny,0],
                    [0,siny,cosy,0],
                    [0,0,0,1]]);
            res = math.multiply(res,a2);
        }
        var a1 = math.matrix([[1,0,0,-cl.a.x],
                [0,1,0,-cl.a.y],
                [0,0,1,-cl.a.z],
                [0,0,0,1]]);
        res = math.multiply(res,a1);
    } else {
        var res = math.matrix([
                    [1,0,0,0],
                    [0,1,0,0],
                    [0,0,1,0],
                    [0,0,0,1]]);
    }
    if (m != 0) {
        var a8 = math.matrix([[1,0,0,dir.x*m],
                [0,1,0,dir.y*m],
                [0,0,1,dir.z*m],
                [0,0,0,1]]);
        res = math.multiply(res,a8);
    }
    var t = {x:0,y:1,z:2}
    var matr = {};
    axis.forEach(function(i) {
        matr[i] = {};
        axis.forEach(function(j) {
            matr[i][j] = res._data[t[i]][t[j]];
        });
        matr[i].d = res._data[t[i]][3];
    });
    return matr;
}

function moveRotate(cp, m) {
    var c = {};
    axis.forEach(function(i) {
        c[i] = m[i].x * cp.x
                + m[i].y * cp.y
                + m[i].z * cp.z
                + m[i].d;
    });
    return c;
}

function calcVertexesCoords(matr) {
    var c = {};
    var s = csize / 2;
    //var v = calcDirection(cl,m,r);
    ['x','-x'].forEach(function(i) {
        ['y','-y'].forEach(function(j) {
            ['z','-z'].forEach(function(k) {
                var v = i+j+k;
                c[v] = {};
                c[v].x = cc.x + (i == 'x' ? s : -s);
                c[v].y = cc.y + (j == 'y' ? s : -s);
                c[v].z = cc.z + (k == 'z' ? s : -s);
                c[v] = moveRotate(c[v],matr);
            });
        });
    });
    return c;
}

function calc3dCoords(c) {
    return {
        x: { x: -c.x*sin60, y: -c.x*cos60 },
        y: { x:  c.y*sin60, y: -c.y*cos60 },
        z: { x:  0,           y:  c.z }
    };
}

function calcPersp(c, op) {
    var eq = calcLineEq({a: op, b: c});
    var t = -eq.z.s/eq.z.d;
    return { x: eq.x.s+eq.x.d*t,
                y: eq.y.s+eq.y.d*t };
}
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
    surf.forEach(function(i) {
        plot[i] = {};
        plot[i].marker = plot.svg.marker(6,6, function(add) {
            add.polygon('0,0,6,3,0,6').addClass('arrow ' + i);
        }).viewbox(0,0,6,6);
    });
    plot.marker = plot.svg.marker(6,6, function(add) {
        add.polygon('0,0,6,3,0,6').addClass('arrow');
    }).viewbox(0,0,6,6);
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

function drawLine3d(plot) {
    var line = {};
    line.b = drawPoint3d(plot);
    line.b.point.addClass('invisible');
    surf.forEach(function(i) {
        line.b[i].point.addClass('invisible');
    })
    surf.forEach(function(i) {
        line[i] = plot.g.line(0,0,0,0).addClass('line dashed ' + i);
        line[i].marker('end',plot[i].marker);
    });
    line.line = plot.g.line(0,0,0,0).addClass('line');
    line.line.marker('end', plot.marker);
    line.a = drawPoint3d(plot);
    return line;
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

function drawCube3d(plot) {
    return drawCube(plot);
}

function redrawCube3d(cube, matr, op) {
    redrawCube(cube,matr,op, false);
}

// Plotting POV

function drawPOVGrid(plot) {
    plot.g = plot.svg.group().scale(1, -1);
    ['x','y'].forEach(function(i) {
        plot[i] = {};
        plot[i].g = plot.g.group().addClass(i);
        plot[i].axis = plot[i].g.line(0,0,0,0).addClass('line');
        plot[i].arrow = plot[i].g.polygon('0,0,0,0,0,0').addClass('arrow');
        plot[i].textp = plot.svg.plain(i[0]).addClass('sub');
        plot[i].textn = plot.svg.plain('-' + i[0]).addClass('sub');
    });
    plot.marker = plot.svg.marker(6,6, function(add) {
        add.polygon('0,0,6,3,0,6').addClass('arrow');
    }).viewbox(0,0,6,6);
}

function redrawPOVGrid(plot, vb) {
    plot.svg.viewbox(-vb,-vb,vb*2,vb*2);
    plot.x.axis.attr({ x1: -vb, y1: 0, x2: vb, y2: 0});
    plot.x.arrow.attr({ points: `${vb} ${0}, ${vb-4} 2, ${vb-4} -2`});
    plot.x.textp.attr({ x: vb-3, y: -3 });
    plot.x.textn.attr({ x: -vb+3.4, y: -3 });
    plot.y.axis.attr({ x1: 0, y1: -vb, x2: 0, y2: vb});
    plot.y.arrow.attr({ points: `${0} ${vb}, 2 ${vb-4}, -2 ${vb-4}`});
    plot.y.textp.attr({x: 2.5, y: -vb+5});
    plot.y.textn.attr({x: 2.5, y: vb-5 });
}

function drawLinePOV(plot) {
    var line = {};
    line.line = plot.g.line(0,0,0,0).addClass('line');
    line.line.marker('end', plot.marker);
    line.a = plot.g.circle(r).addClass('point');
    return line;
}

function redrawLinePOV(line, c, op) {
    var ac = calcPersp(c.a,op);
    var bc = calcPersp(c.b,op);
    line.a.attr({cx: ac.x, cy: ac.y });
    line.line.attr({x1: ac.x, y1: ac.y,
                    x2: bc.x, y2: bc.y});

}

function drawCubePOV(plot) {
    return drawCube3d(plot);
}

function redrawCubePOV(cube, matr, op) {
    redrawCube(cube,matr,op, true);
}

draw3dGrid(plot3d);
redraw3dGrid(plot3d, viewboxBase);
drawPOVGrid(plotPOV);
redrawPOVGrid(plotPOV, viewboxBase);

cube3d = drawCube3d(plot3d);
line3d = drawLine3d(plot3d);
observePoint3d = drawPoint3d(plot3d);
redrawPoint3d(observePoint3d, getObservePoint());

linePOV = drawLinePOV(plotPOV);
cubePOV = drawCubePOV(plotPOV);
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
    var c = getCoords();
    var a = event.target.id[0];
    var b = event.target.id[1];
    document.getElementById(a + b + '-val').innerText = c[a][b];
    redrawLine3d(line3d, c);
    var op = getObservePoint();
    redrawLinePOV(linePOV, c, op);
    var matr = calcMatrix(c, move.value*1, rotate.value*1);
    redrawCube3d(cube3d, matr, op);
    redrawCubePOV(cubePOV, matr, op);
}

function onmoverotate(event) {
    var matr = calcMatrix(getCoords(),
        move.value*1, rotate.value*1);
    var op = getObservePoint();
    redrawCube3d(cube3d, matr, op);
    redrawCubePOV(cubePOV, matr, op);
}

rotate.oninput = function(event) {
    document.getElementById('rotate-val').innerText = rotate.value;
    onmoverotate(event);
}
move.oninput = function(event) {
    document.getElementById('move-val').innerText = move.value;
    onmoverotate(event);
}
observe.oninput = function(event) {
    document.getElementById('observe-val').innerText = observe.value;
    var op = getObservePoint();
    redrawPoint3d(observePoint3d, op);
    redrawLinePOV(linePOV, getCoords(), op);
    onmoverotate(event);
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

function getObservePoint() {
    return { x: 0, y: 0,
        z: observe.value*1};
}

ab.forEach(function(i) {
    axis.forEach(function(j) {
        var input = document.getElementById(i + j + '-range');
        input.oninput = oninput;
    });
});

scaler.oninput = function() {
    redraw3dGrid(plot3d, scaler.value * viewboxBase);
    redrawPOVGrid(plotPOV, scaler.value * viewboxBase);
};
