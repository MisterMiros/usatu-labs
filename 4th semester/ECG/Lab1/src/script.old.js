var svg2d, svg3d;
var point3d, point3dXY, point3dXZ, point3dYZ, point3dX, point3dY, point3dZ;
var line3dXY, line3dXZ, line3dYZ, line3dX, line3dY, line3dZ;
var point2dXY, point2dXZ, point2dYZ;
var line2dXy, line2dXz, line2dYx, line2dYz, line2dZx, line2dZy, arc2d;
var r = 1.5;
var s = "100%";
var sin60 = Math.sin(Math.PI / 3);
var cos60 = Math.cos(Math.PI / 3);
var inputX = document.getElementById('X');
var inputY = document.getElementById('Y');
var inputZ = document.getElementById('Z');
var scaler = document.getElementById('scaler');
var vb = 50;

function draw3dGrid() {
  svg3d = SVG('3d').viewbox(-vb,-vb,vb*2,vb*2);
  var g3d = svg3d.group().size(s,s).scale(1,-1);
  var gZ = g3d.group().addClass('z');
  gZ.line(0,vb-2,0,0).addClass('line');
  gZ.line(0,0,0,-vb).addClass('line dashed');
  gZ.polygon('0,50,2,46,-2,46').addClass('arrow');
  var gY = gZ.clone().removeClass('z').addClass('y').rotate(240);
  var gX = gZ.clone().removeClass('z').addClass('x').rotate(120);
  g3d.rect(1,1).fill('black').attr({ x: -0.5, y: -0.5 });
  svg3d.plain('X').attr({x: -42, y: 20});
  svg3d.plain('Y').attr({x: 38, y: 20});
  svg3d.plain('Z').attr({x: 2, y: -44});
  line3dXY = g3d.polyline('0,0 0,0').addClass('line pointed');
  line3dXZ = g3d.polyline('0,0 0,0').addClass('line pointed');
  line3dYZ = g3d.polyline('0,0 0,0').addClass('line pointed');
  line3dX = g3d.line(0,0,0,0).addClass('line');
  line3dY = g3d.line(0,0,0,0).addClass('line');
  line3dZ = g3d.line(0,0,0,0).addClass('line');
  point3d = g3d.circle(r).addClass('point').attr({ cx: 0, cy: 0 });
  point3dXY = point3d.clone().addClass('xy');
  point3dXZ = point3d.clone().addClass('xz');
  point3dYZ = point3d.clone().addClass('yz');
  point3dX = point3d.clone().addClass('x');
  point3dY = point3d.clone().addClass('y');
  point3dZ = point3d.clone().addClass('z');
  point3d.fill('lime').front();
}

function draw2dGrid() {
    svg2d = SVG('2d').viewbox(-vb,-vb,vb*2,vb*2);
    var g2d = svg2d.group().scale(1,-1);
    g2d.line(-50,0,50,0).addClass("line");
    g2d.line(0,-50,0,50).addClass("line");
    svg2d.plain('Z').addClass('sub').attr({ x: -6, y: -44 });
    svg2d.plain('-Y').addClass('sub').attr({ x: 2, y: -44 });
    svg2d.plain('-Z').addClass('sub').attr({ x: -7, y: 49 });
    svg2d.plain('Y').addClass('sub').attr({ x: 2, y: 49 });
    svg2d.plain('X').addClass('sub').attr({ x: -49, y: -2 });
    svg2d.plain('-Y').addClass('sub').attr({ x: -51, y: 6 });
    svg2d.plain('-X').addClass('sub').attr({ x: 41, y: -2 });
    svg2d.plain('Y').addClass('sub').attr({ x: 44, y: 6 });

    line2dXy = g2d.line(0,0,0,0).addClass('line x');
    line2dXz = line2dXy.clone();
    line2dYx = g2d.line(0,0,0,0).addClass('line y');
    line2dYz = line2dYx.clone();
    line2dZx = g2d.line(0,0,0,0).addClass('line z');
    line2dZy = line2dZx.clone();

    point2dXY = g2d.circle(r).addClass('point xy').attr({ cx: 0, cy: 0});
    point2dXZ = g2d.circle(r).addClass('point xz').attr({ cx: 0, cy: 0});
    point2dYZ = g2d.circle(r).addClass('point yz').attr({ cx: 0, cy: 0});

    arc2d = g2d.path().addClass('line y');
}

function drawPoint3d(x, y, z) {
  var xc = { x: -x * sin60, y: -x * cos60};
  var yc = { x: y * sin60, y: -y * cos60 };
  var zc = { x: 0, y: z + 0};
  var p = { x: xc.x + yc.x + zc.x, y: xc.y + yc.y + zc.y }
  point3dX.attr({ cx: xc.x, cy: xc.y})
  point3dY.attr({ cx: yc.x, cy: yc.y})
  point3dZ.attr({ cx: zc.x, cy: zc.y})
  line3dX.attr({x1: yc.x + zc.x, y1: yc.y + zc.y, x2: p.x, y2: p.y});
  line3dY.attr({x1: xc.x + zc.x, y1: xc.y + zc.y, x2: p.x, y2: p.y});
  line3dZ.attr({x1: xc.x + yc.x, y1: xc.y + yc.y, x2: p.x, y2: p.y});
  point3dXY.attr({ cx: xc.x + yc.x, cy: xc.y + yc.y});
  line3dXY.plot([[xc.x,xc.y],[xc.x + yc.x, xc.y + yc.y], [yc.x,yc.y]]);
  point3dXZ.attr({ cx: xc.x + zc.x, cy: xc.y + zc.y })
  line3dXZ.plot([[xc.x,xc.y],[xc.x + zc.x, xc.y + zc.y], [zc.x,zc.y]]);
  point3dYZ.attr({ cx: yc.x + zc.x, cy: yc.y + zc.y })
  line3dYZ.plot([[yc.x,yc.y],[yc.x + zc.x, yc.y + zc.y], [zc.x,zc.y]]);
  point3d.attr({ cx: p.x, cy: p.y});
}

function drawPoint2d(x,y,z) {
  point2dXY.attr({ cx: -x, cy: -y });
  point2dXZ.attr({ cx: -x, cy: z });
  point2dYZ.attr({ cx: y, cy: z });

  line2dXy.attr({ x1: -x, y1: -y, x2: -x, y2: 0});
  line2dXz.attr({ x1: -x, y1: z,  x2: -x, y2: 0});
  line2dYx.attr({ x1: -x, y1: -y, x2: 0,  y2: -y });
  line2dYz.attr({ x1: y,  y1: z,  x2: y,  y2: 0});
  line2dZx.attr({ x1: -x, y1: z,  x2: 0, y2: z});
  line2dZy.attr({ x1: y,  y1: z,  x2: 0, y2: z});

  arc2d.attr({ d: `M ${y} 0 A ${y} ${y} 0 0 0 0 ${-y}`});
}

function scale(s) {
  svg3d.viewbox(-vb*s,-vb*s,vb*s*2,vb*s*2);
  svg2d.viewbox(-vb*s,-vb*s,vb*s*2,vb*s*2);
}



function oninput() {
  drawPoint3d(inputX.value * 1, inputY.value * 1, inputZ.value * 1);
  drawPoint2d(inputX.value * 1, inputY.value * 1, inputZ.value * 1);
}

function onscaler() {
  scale(scaler.value * 1);
}

inputX.oninput = oninput;
inputY.oninput = oninput;
inputZ.oninput = oninput;
scaler.oninput = onscaler;
document.getElementById("c-button").onclick = function() {
    var form = document.getElementById("c-form");
    if (form.style.display == 'none') {
        form.style.display = 'block';
    }
    else {
        form.style.display = 'none';
    }
};


draw3dGrid();
draw2dGrid();
