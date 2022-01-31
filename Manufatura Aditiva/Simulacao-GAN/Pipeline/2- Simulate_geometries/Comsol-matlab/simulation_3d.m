function [model,E] = simulation_3d(array,theta,model_name,save_model)

% teste.m
%
% Model exported on Feb 25 2021, 14:17 by COMSOL 5.5.0.292.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath(['C:\Users\lucas\Documents\Github\INT\Manufatura Aditiva\Simula' native2unicode(hex2dec({'00' 'e7'}), 'unicode')  native2unicode(hex2dec({'00' 'e3'}), 'unicode') 'o-GAN\COMSOL-Matlab']);

load = 100;
young = 100.0;
poisson = 0.3;
p = 4500;
arrange_size = 0.048;
unit_size = arrange_size/6;
thickness = 0.0025;
resolution = length(array);
void_size = arrange_size/(6*resolution);

model.param.set('load', [num2str(load,'%d') '' '[N/m^2]'], 'prescribed load');
model.param.set('young', [num2str(young,'%.2f') '' '[GPa]'], 'young''s modulus');
model.param.set('poisson', num2str(poisson,'%.2f'), 'poisson''s modulus');
model.param.set('p', [num2str(p,'%d') '' '[Kg/m^3]'], 'density');
model.param.set('void_size', [num2str(void_size,'%.5f') '' '[m]'], 'void size');
model.param.set('unit_size', [num2str(unit_size,'%.4f') '' '[m]'], 'unit size');
model.param.set('arrange_size', [num2str(arrange_size,'%.4f') '' '[m]'], 'arrange size');
model.param.set('thickness', [num2str(thickness,'%.5f') '' '[m]'], 'specimen thickness');
model.param.set('theta', [num2str(theta,'%d') '' '[deg]']);

model.component.create('comp1', true);
model.component('comp1').geom.create('geom1', 3);
model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('wp1', 'WorkPlane');
model.component('comp1').geom('geom1').feature('wp1').set('unite', true);
model.component('comp1').geom('geom1').run('wp1');

model.component('comp1').geom('geom1').feature('wp1').geom.create('sq', 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('sq').set('size', [unit_size unit_size]);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('sq').set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('sq').set('pos', [0 0]);
model.component('comp1').geom('geom1').feature('wp1').geom.run('sq');
rectangles = {};
r = 1;
for i = (1:resolution)
    pos_y = unit_size/2 - (i-0.5)*void_size;
    for j = (1:resolution)
        if array(i,j) == 0
            rect = ['r' '' num2str(r,'%d')];
            rectangles{r} = rect;
            pos_x = (j-0.5)*void_size - unit_size/2;
            model.component('comp1').geom('geom1').feature('wp1').geom.create(rect, 'Rectangle');
            model.component('comp1').geom('geom1').feature('wp1').geom.feature(rect).set('base', 'center');
            model.component('comp1').geom('geom1').feature('wp1').geom.feature(rect).set('size', [void_size void_size]);
            model.component('comp1').geom('geom1').feature('wp1').geom.feature(rect).set('pos', [pos_x pos_y]);
            model.component('comp1').geom('geom1').feature('wp1').geom.run(rect);
            r = r + 1;
        end
    end
end

model.component('comp1').geom('geom1').feature('wp1').geom.create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif1').selection('input').set({'sq'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif1').selection('input2').set(rectangles);
model.component('comp1').geom('geom1').feature('wp1').geom.run('dif1');

model.component('comp1').geom('geom1').feature('wp1').geom.create('rot1', 'Rotate');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot1').selection('input').set({'dif1'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot1').set('pos', {'unit_size/2' '0'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot1').setIndex('pos', '-unit_size/2', 1);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot1').set('keep', true);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot1').set('rot', -90);
model.component('comp1').geom('geom1').feature('wp1').geom.run('rot1');

model.component('comp1').geom('geom1').feature('wp1').geom.create('rot2', 'Rotate');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot2').set('rot', -180);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot2').set('pos', {'unit_size/2' '0'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot2').setIndex('pos', '-unit_size/2', 1);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot2').selection('input').set({'dif1'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot2').set('keep', true);
model.component('comp1').geom('geom1').feature('wp1').geom.run('rot2');

model.component('comp1').geom('geom1').feature('wp1').geom.create('rot3', 'Rotate');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot3').selection('input').set({'dif1'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot3').set('rot', -270);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot3').set('pos', {'unit_size/2' '0'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot3').setIndex('pos', '-unit_size/2', 1);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot3').set('keep', true);
model.component('comp1').geom('geom1').feature('wp1').geom.run('rot3');

model.component('comp1').geom('geom1').feature('wp1').geom.create('uni1', 'Union');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni1').selection('input').set({'dif1' 'rot1' 'rot2' 'rot3'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni1').set('intbnd', false);
model.component('comp1').geom('geom1').feature('wp1').geom.run('uni1');

model.component('comp1').geom('geom1').feature('wp1').geom.useConstrDim(false);

model.component('comp1').geom('geom1').feature('wp1').geom.create('arrec1', 'Array');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('arrec1').selection('input').set({'uni1'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('arrec1').set('fullsize', [5 5]);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('arrec1').set('displ', {'2*unit_size' '2*unit_size'});
model.component('comp1').geom('geom1').feature('wp1').geom.run('arrec1');

model.component('comp1').geom('geom1').feature('wp1').geom.create('uni2', 'Union');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni2').selection('input').set({'arrec1'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni2').set('keep', false);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni2').set('intbnd', false);
model.component('comp1').geom('geom1').feature('wp1').geom.run('uni2');

model.component('comp1').geom('geom1').feature('wp1').geom.create('rot4', 'Rotate');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot4').selection('input').set({'uni2'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot4').set('rot', 'theta');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('rot4').set('pos', {'arrange_size-3*unit_size/2' 'arrange_size-5*unit_size/2'});
model.component('comp1').geom('geom1').feature('wp1').geom.run('rot4');

model.component('comp1').geom('geom1').feature('wp1').geom.create('sq1', 'Square');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('sq1').set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('sq1').set('size', '3*arrange_size');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('sq1').set('pos', {'arrange_size-3*unit_size/2' 'arrange_size-5*unit_size/2'});

model.component('comp1').geom('geom1').feature('wp1').geom.run('sq1');

r = r + 1;
model.component('comp1').geom('geom1').feature('wp1').geom.create(num2str(r,'%i'), 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('size', {'arrange_size-2*void_size' 'arrange_size'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('pos', {'arrange_size-3*unit_size/2' 'arrange_size-5*unit_size/2'});
model.component('comp1').geom('geom1').feature('wp1').geom.run(num2str(r,'%i'));

model.component('comp1').geom('geom1').feature('wp1').geom.create('dif2', 'Difference');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif2').selection('input').set({'sq1'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif2').selection('input2').set({num2str(r,'%i')});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif2').set('intbnd', false);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif2').set('keep', false);
model.component('comp1').geom('geom1').feature('wp1').geom.run('dif2');

model.component('comp1').geom('geom1').feature('wp1').geom.create('dif3', 'Difference');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif3').selection('input').set({'rot4'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif3').selection('input2').set({'dif2'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif3').set('intbnd', false);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif3').set('keep', false);
model.component('comp1').geom('geom1').feature('wp1').geom.run('dif3');

r = r + 1;

model.component('comp1').geom('geom1').feature('wp1').geom.create(num2str(r,'%i'), 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('size', {'arrange_size' 'arrange_size/4'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('pos', {'arrange_size-3*unit_size/2' 'arrange_size/8-unit_size'});
model.component('comp1').geom('geom1').feature('wp1').geom.run(num2str(r,'%i'));

r = r + 1;

model.component('comp1').geom('geom1').feature('wp1').geom.create(num2str(r,'%i'), 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('size', {'arrange_size' 'arrange_size/4'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('pos', {'arrange_size-3*unit_size/2' '11*arrange_size/8-unit_size'});
model.component('comp1').geom('geom1').feature('wp1').geom.run(num2str(r,'%i'));

r = r + 1;

model.component('comp1').geom('geom1').feature('wp1').geom.create(num2str(r,'%i'), 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('size', {'void_size' 'arrange_size'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('pos', {'arrange_size/2-3*unit_size/2+void_size/2' 'arrange_size-5*unit_size/2'});
model.component('comp1').geom('geom1').feature('wp1').geom.run(num2str(r,'%i'));

r = r + 1;

model.component('comp1').geom('geom1').feature('wp1').geom.create(num2str(r,'%i'), 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('size', {'void_size' 'arrange_size'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature(num2str(r,'%i')).set('pos', {'3*arrange_size/2-3*unit_size/2-void_size/2' 'arrange_size-5*unit_size/2'});
model.component('comp1').geom('geom1').feature('wp1').geom.run(num2str(r,'%i'));

model.component('comp1').geom('geom1').feature('wp1').geom.create('uni3', 'Union');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni3').selection('input').set({'dif3' num2str(r-3,'%i') num2str(r-2,'%i') num2str(r-1,'%i') num2str(r,'%i')});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni3').set('intbnd', false);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni3').set('keep', false);
model.component('comp1').geom('geom1').feature('wp1').geom.run('uni2');

model.component('comp1').geom('geom1').feature.create('ext1', 'Extrude');
model.component('comp1').geom('geom1').feature('ext1').set('workplane', 'wp1');
model.component('comp1').geom('geom1').feature('ext1').selection('input').set({'wp1'});
model.component('comp1').geom('geom1').feature('ext1').setIndex('distance', 'thickness', 0);
model.component('comp1').geom('geom1').run('ext1');

% points = mphgetcoords(model,'geom1','domain',1);
% points = points(1,:);
% num_points = length(points);
% model.component('comp1').geom('geom1').feature('wp1').geom.create('fil1', 'Fillet');
% model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil1').selection('point').set('uni3',[1:num_points/2]);
% model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil1').set('radius', 'void_size/5');
% model.component('comp1').geom('geom1').feature('wp1').geom.run('fil1');

model.component('comp1').geom('geom1').feature('wp1').geom.run;

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').propertyGroup('def').set('density', 'p');
model.component('comp1').material('mat1').propertyGroup('def').descr('density_symmetry', '');
model.component('comp1').material('mat1').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat1').propertyGroup('Enu').set('youngsmodulus', 'young');
model.component('comp1').material('mat1').propertyGroup('Enu').descr('youngsmodulus_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Enu').set('poissonsratio', 'poisson');
model.component('comp1').material('mat1').propertyGroup('Enu').descr('poissonsratio_symmetry', '');


model.component('comp1').mesh('mesh1').create('ftet1', 'FreeTet');
model.component('comp1').mesh('mesh1').run('ftet1');

model.component('comp1').physics.create('solid', 'SolidMechanics', 'geom1');
model.component('comp1').physics('solid').create('bndl1', 'BoundaryLoad', 2);
model.component('comp1').physics('solid').feature('bndl1').selection.set([7]);
model.component('comp1').physics('solid').feature('bndl1').set('FperArea', {'0' 'load' '0'});
model.component('comp1').physics('solid').create('disp1', 'Displacement2', 2);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 2);
model.component('comp1').physics('solid').feature('disp1').selection.set([2]);

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').feature('stat').activate('solid', true);

model.sol.create('sol1');
model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('termonres', 'auto');
model.sol('sol1').feature('s1').feature('fc1').set('reserrfact', 1000);
model.sol('sol1').feature('s1').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('d1').set('pivotperturb', 1.0E-9);
model.sol('sol1').feature('s1').feature('d1').label('Suggested Direct Solver (solid)');
model.sol('sol1').feature('s1').create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'gmres');
model.sol('sol1').feature('s1').feature('i1').set('rhob', 400);
model.sol('sol1').feature('s1').feature('i1').set('nlinnormuse', true);
model.sol('sol1').feature('s1').feature('i1').label('Suggested Iterative Solver (solid)');
model.sol('sol1').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('prefun', 'gmg');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').create('so1', 'SOR');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('so1').set('relax', 0.8);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').create('so1', 'SOR');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('so1').set('relax', 0.8);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-9);
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'd1');
model.sol('sol1').feature('s1').feature('fc1').set('termonres', 'auto');
model.sol('sol1').feature('s1').feature('fc1').set('reserrfact', 1000);
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.result.create('pgsurf', 'PlotGroup3D');

model.result('pgsurf').set('data', 'dset1');
model.result('pgsurf').create('surf1', 'Surface');
model.result('pgsurf').feature('surf1').set('expr', {'v'});
model.result('pgsurf').label('Displacement Y (solid)');
model.result('pgsurf').feature('surf1').set('colortable', 'RainbowLight');
model.result('pgsurf').feature('surf1').set('resolution', 'normal');
model.result('pgsurf').feature('surf1').create('def', 'Deform');
model.result('pgsurf').feature('surf1').feature('def').set('expr', {'u' 'v' 'w'});
model.result('pgsurf').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pgsurf').feature('surf1').feature('def').set('scale', '0');
model.result('pgsurf').run;

model.sol('sol1').runAll;

data = mpheval(model,'v','selection',7,'edim','boundary');
disp = data.d1(fix(length(data.d1)/2))
strain = disp/(3*arrange_size/2);
E = load/strain;

if save_model == true
    mphsave(model,model_name);
end

end