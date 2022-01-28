function [model,E] = simulation_2d(array,theta,model_name,save_model)

% teste.m
%
% Model exported on Feb 25 2021, 14:17 by COMSOL 5.5.0.292.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath(['C:\Users\lucas\Documents\Github\INT\Manufatura Aditiva\Simula' native2unicode(hex2dec({'00' 'e7'}), 'unicode')  native2unicode(hex2dec({'00' 'e3'}), 'unicode') 'o-GAN\COMSOL-Matlab']);

load = 100.0;
young = 100.0;
poisson = 0.3;
p = 4500;
arrange_size = 0.048;
unit_size = arrange_size/6;
thickness = 0.0025;
resolution = length(array);
void_size = arrange_size/(6*resolution);

model.param.set('load', [num2str(load,'%d') '' '[N]'], 'prescribed load');
model.param.set('young', [num2str(young,'%.2f') '' '[GPa]'], 'young''s modulus');
model.param.set('p', [num2str(p,'%d') '' '[GPa]'], 'density');
model.param.set('poisson', num2str(poisson,'%.2f'), 'poisson''s modulus');
model.param.set('void_size', [num2str(void_size,'%.5f') '' '[m]'], 'void size');
model.param.set('unit_size', [num2str(unit_size,'%.4f') '' '[m]'], 'unit size');
model.param.set('arrange_size', [num2str(arrange_size,'%.4f') '' '[m]'], 'arrange size');
model.param.set('thickness', [num2str(thickness,'%.5f') '' '[m]'], 'specimen thickness');
model.param.set('theta', [num2str(theta,'%d') '' '[deg]']);

model.component.create('comp1', true);
model.component('comp1').geom.create('geom1', 2);
model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('sq', 'Rectangle');
model.component('comp1').geom('geom1').feature('sq').set('size', [unit_size unit_size]);
model.component('comp1').geom('geom1').feature('sq').set('base', 'center');
model.component('comp1').geom('geom1').feature('sq').set('pos', [0 0]);
model.component('comp1').geom('geom1').run('sq');
rectangles = {};
r = 1;
for i = (1:resolution)
    pos_y = unit_size/2 - (i-0.5)*void_size;
    for j = (1:resolution)
        if array(i,j) == 0
            rect = ['r' '' num2str(r,'%d')];
            rectangles{r} = rect;
            pos_x = (j-0.5)*void_size - unit_size/2;
            model.component('comp1').geom('geom1').create(rect, 'Rectangle');
            model.component('comp1').geom('geom1').feature(rect).set('base', 'center');
            model.component('comp1').geom('geom1').feature(rect).set('size', [void_size void_size]);
            model.component('comp1').geom('geom1').feature(rect).set('pos', [pos_x pos_y]);
            model.component('comp1').geom('geom1').run(rect);
            r = r + 1;
        end
    end
end


model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'sq'});
model.component('comp1').geom('geom1').feature('dif1').selection('input2').set(rectangles);
model.component('comp1').geom('geom1').run('dif1');

model.component('comp1').geom('geom1').create('rot1', 'Rotate');
model.component('comp1').geom('geom1').feature('rot1').selection('input').set({'dif1'});
model.component('comp1').geom('geom1').feature('rot1').set('pos', {'unit_size/2' '0'});
model.component('comp1').geom('geom1').feature('rot1').setIndex('pos', '-unit_size/2', 1);
model.component('comp1').geom('geom1').feature('rot1').set('keep', true);
model.component('comp1').geom('geom1').feature('rot1').set('rot', -90);
model.component('comp1').geom('geom1').run('rot1');

model.component('comp1').geom('geom1').create('rot2', 'Rotate');
model.component('comp1').geom('geom1').feature('rot2').set('rot', -180);
model.component('comp1').geom('geom1').feature('rot2').set('pos', {'unit_size/2' '0'});
model.component('comp1').geom('geom1').feature('rot2').setIndex('pos', '-unit_size/2', 1);
model.component('comp1').geom('geom1').feature('rot2').selection('input').set({'dif1'});
model.component('comp1').geom('geom1').feature('rot2').set('keep', true);
model.component('comp1').geom('geom1').run('rot2');

model.component('comp1').geom('geom1').create('rot3', 'Rotate');
model.component('comp1').geom('geom1').feature('rot3').selection('input').set({'dif1'});
model.component('comp1').geom('geom1').feature('rot3').set('rot', -270);
model.component('comp1').geom('geom1').feature('rot3').set('pos', {'unit_size/2' '0'});
model.component('comp1').geom('geom1').feature('rot3').setIndex('pos', '-unit_size/2', 1);
model.component('comp1').geom('geom1').feature('rot3').set('keep', true);
model.component('comp1').geom('geom1').run('rot3');

model.component('comp1').geom('geom1').create('uni1', 'Union');
model.component('comp1').geom('geom1').feature('uni1').selection('input').set({'dif1' 'rot1' 'rot2' 'rot3'});
model.component('comp1').geom('geom1').feature('uni1').set('intbnd', false);
model.component('comp1').geom('geom1').run('uni1');

model.component('comp1').geom('geom1').useConstrDim(false);

model.component('comp1').geom('geom1').create('arrec1', 'Array');
model.component('comp1').geom('geom1').feature('arrec1').selection('input').set({'uni1'});
model.component('comp1').geom('geom1').feature('arrec1').set('fullsize', [3 3]);
model.component('comp1').geom('geom1').feature('arrec1').set('displ', {'2*unit_size' '2*unit_size'});
model.component('comp1').geom('geom1').run('arrec1');
model.component('comp1').geom('geom1').create('uni2', 'Union');
model.component('comp1').geom('geom1').feature('uni2').selection('input').set({'arrec1'});
model.component('comp1').geom('geom1').feature('uni2').set('intbnd', false);

model.component('comp1').geom('geom1').create('arrec2', 'Array');
model.component('comp1').geom('geom1').feature('arrec2').set('fullsize', [2 2]);
model.component('comp1').geom('geom1').feature('arrec2').set('displ', {'arrange_size' '0'});
model.component('comp1').geom('geom1').feature('arrec2').setIndex('displ', 'arrange_size', 1);
model.component('comp1').geom('geom1').feature('arrec2').selection('input').set({'uni2'});
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run('arrec2');

model.component('comp1').geom('geom1').create('uni3', 'Union');
model.component('comp1').geom('geom1').feature('uni3').selection('input').set({'arrec2'});
model.component('comp1').geom('geom1').feature('uni3').set('keep', false);
model.component('comp1').geom('geom1').feature('uni3').set('intbnd', false);
model.component('comp1').geom('geom1').run('uni3');

model.component('comp1').geom('geom1').create('rot4', 'Rotate');
model.component('comp1').geom('geom1').feature('rot4').selection('input').set({'uni3'});
model.component('comp1').geom('geom1').feature('rot4').set('rot', 'theta');
model.component('comp1').geom('geom1').feature('rot4').set('pos', {'arrange_size-unit_size/2' '0'});
model.component('comp1').geom('geom1').feature('rot4').setIndex('pos', 'arrange_size-unit_size/2', 1);
model.component('comp1').geom('geom1').run('rot4');

model.component('comp1').geom('geom1').create('sq1', 'Square');
model.component('comp1').geom('geom1').feature('sq1').set('base', 'center');
model.component('comp1').geom('geom1').feature('sq1').set('size', '4*arrange_size');
model.component('comp1').geom('geom1').feature('sq1').set('pos', {'arrange_size-unit_size/2' '0'});
model.component('comp1').geom('geom1').feature('sq1').setIndex('pos', 'arrange_size-unit_size/2', 1);

model.component('comp1').geom('geom1').run('sq1');

r = r + 1;
model.component('comp1').geom('geom1').create(num2str(r,'%i'), 'Rectangle');
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('base', 'center');
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('size', [arrange_size-2*void_size arrange_size]);
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('pos', [arrange_size+unit_size/2 arrange_size-unit_size/2]);
model.component('comp1').geom('geom1').run(num2str(r,'%i'));

model.component('comp1').geom('geom1').create('dif2', 'Difference');
model.component('comp1').geom('geom1').feature('dif2').selection('input').set({'sq1'});
model.component('comp1').geom('geom1').feature('dif2').selection('input2').set({num2str(r,'%i')});
model.component('comp1').geom('geom1').feature('dif2').set('intbnd', false);
model.component('comp1').geom('geom1').feature('dif2').set('keep', false);
model.component('comp1').geom('geom1').run('dif2');

model.component('comp1').geom('geom1').create('dif3', 'Difference');
model.component('comp1').geom('geom1').feature('dif3').selection('input').set({'rot4'});
model.component('comp1').geom('geom1').feature('dif3').selection('input2').set({'dif2'});
model.component('comp1').geom('geom1').feature('dif3').set('intbnd', false);
model.component('comp1').geom('geom1').feature('dif3').set('keep', false);
model.component('comp1').geom('geom1').run('dif3');

r = r + 1;

model.component('comp1').geom('geom1').create(num2str(r,'%i'), 'Rectangle');
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('base', 'center');
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('size', [arrange_size arrange_size/4]);
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('pos', [arrange_size+unit_size/2 arrange_size/4+unit_size/4]);
model.component('comp1').geom('geom1').run(num2str(r,'%i'));

r = r + 1;

model.component('comp1').geom('geom1').create(num2str(r,'%i'), 'Rectangle');
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('base', 'center');
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('size', [arrange_size arrange_size/4]);
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('pos', [arrange_size+unit_size/2 7*arrange_size/4-5*unit_size/4]);
model.component('comp1').geom('geom1').run(num2str(r,'%i'));

r = r + 1;
model.component('comp1').geom('geom1').create(num2str(r,'%i'), 'Rectangle');
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('base', 'center');
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('size', [void_size arrange_size]);
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('pos', [arrange_size/2+unit_size/2+void_size/2 arrange_size-unit_size/2]);
model.component('comp1').geom('geom1').run(num2str(r,'%i'));

r = r + 1;
model.component('comp1').geom('geom1').create(num2str(r,'%i'), 'Rectangle');
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('base', 'center');
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('size', [void_size arrange_size]);
model.component('comp1').geom('geom1').feature(num2str(r,'%i')).set('pos', [3*arrange_size/2+unit_size/2-void_size/2 arrange_size-unit_size/2]);
model.component('comp1').geom('geom1').run(num2str(r,'%i'));

model.component('comp1').geom('geom1').create('uni4', 'Union');
model.component('comp1').geom('geom1').feature('uni4').selection('input').set({'dif3' num2str(r-3,'%i') num2str(r-2,'%i') num2str(r-1,'%i') num2str(r,'%i')});
model.component('comp1').geom('geom1').feature('uni4').set('intbnd', false);
model.component('comp1').geom('geom1').feature('uni4').set('keep', false);
model.component('comp1').geom('geom1').run;

% points = mphgetcoords(model,'geom1','domain',1);
% points = points(1,:);
% num_points = length(points);
% model.component('comp1').geom('geom1').create('fil1', 'Fillet');
% model.component('comp1').geom('geom1').feature('fil1').selection('point').set('uni4',[1:num_points]);
% model.component('comp1').geom('geom1').feature('fil1').set('radius', 'void_size/5');
% model.component('comp1').geom('geom1').run('fil1');
model.component('comp1').geom('geom1').run;

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat1').label('Structural steel');
model.component('comp1').material('mat1').propertyGroup('def').set('density', 'p');
model.component('comp1').material('mat1').propertyGroup('def').descr('density_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Enu').set('youngsmodulus', 'young');
model.component('comp1').material('mat1').propertyGroup('Enu').descr('youngsmodulus_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Enu').set('poissonsratio', 'poisson');
model.component('comp1').material('mat1').propertyGroup('Enu').descr('poissonsratio_symmetry', '');


model.component('comp1').physics.create('solid', 'SolidMechanics', 'geom1');

model.component('comp1').physics('solid').create('disp2', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp2').label('Bottom Displacement');
model.component('comp1').physics('solid').feature('disp2').selection.set([2]);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 0);

model.component('comp1').physics('solid').create('bndl1', 'BoundaryLoad', 1);
model.component('comp1').physics('solid').feature('bndl1').label('Top Load');
model.component('comp1').physics('solid').feature('bndl1').selection.set([5]);
model.component('comp1').physics('solid').feature('bndl1').set('FperArea', [0 load 0]);

model.component('comp1').physics('solid').prop('Type2D').set('Type2D', 'PlaneStress');
model.component('comp1').physics('solid').prop('d').set('d', '1e-5');

model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
model.component('comp1').mesh('mesh1').feature('ftri1').selection.geom('geom1');
model.component('comp1').mesh('mesh1').feature('size').set('hauto', 6);
model.component('comp1').mesh('mesh1').run;

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
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('porder', 'constant');
model.sol('sol1').feature('s1').feature('p1').set('control', 'stat');
model.sol('sol1').feature('s1').set('control', 'stat');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('termonres', 'auto');
model.sol('sol1').feature('s1').feature('fc1').set('reserrfact', 1000);
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'dDef');
model.sol('sol1').feature('s1').feature('fc1').set('termonres', 'auto');
model.sol('sol1').feature('s1').feature('fc1').set('reserrfact', 1000);
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.result.create('pgsurf', 'PlotGroup2D');
model.result('pgsurf').set('data', 'dset1');
model.result('pgsurf').create('surf1', 'Surface');
model.result('pgsurf').feature('surf1').set('expr', {'v'});
model.result('pgsurf').label('Stress (solid)');
model.result('pgsurf').feature('surf1').set('colortable', 'RainbowLight');
model.result('pgsurf').feature('surf1').set('resolution', 'normal');
model.result('pgsurf').feature('surf1').create('def', 'Deform');
model.result('pgsurf').feature('surf1').feature('def').set('expr', {'u' 'v'});
model.result('pgsurf').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pgsurf').create('con1', 'Contour');
model.result('pgsurf').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pgsurf').feature('con1').create('def', 'Deform');
model.result('pgsurf').feature('con1').feature('def').set('expr', {'u' 'v'});
model.result('pgsurf').feature('con1').feature('def').set('descr', 'Displacement field');
model.result('pgsurf').feature('con1').set('inheritplot', 'surf1');
model.result('pgsurf').feature('con1').set('inheritcolor', false);
model.result('pgsurf').feature('con1').set('inheritrange', false);
model.result('pgsurf').feature('con1').set('number', 10);
model.result('pgsurf').feature('con1').set('colortable', 'Twilight');
model.result('pgsurf').feature('con1').set('descractive', true);
model.result('pgsurf').feature('con1').set('descr', 'Effective plastic strain');
model.result('pgsurf').feature('con1').label('Plastic strain');
model.result('pgsurf').set('legendpos', 'rightdouble');
model.result('pgsurf').label('Displacement Y (solid)');
model.result('pgsurf').feature('surf1').feature('def').set('scaleactive', true);
model.result('pgsurf').feature('surf1').feature('def').set('scale', 0);
model.result('pgsurf').run;

model.sol('sol1').runAll;


if save_model == true
    mphsave(model,model_name);
end

data = mpheval(model,'v','selection',5,'edim','boundary');

disp = data.d1(fix(length(data.d1)/2))
strain = disp/(3*arrange_size/2);
E = load/strain;

end

