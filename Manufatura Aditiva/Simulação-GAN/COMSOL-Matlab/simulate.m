function [out,E] = simulate(resolution)

% teste.m
%
% Model exported on Feb 25 2021, 14:17 by COMSOL 5.5.0.292.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath(['C:\Users\lucas\Documents\Github\INT\Manufatura Aditiva\Simula' native2unicode(hex2dec({'00' 'e7'}), 'unicode')  native2unicode(hex2dec({'00' 'e3'}), 'unicode') 'o-GAN\COMSOL-Matlab']);

disp = 0.0;
zeta = 16.93;
H = 129.24;
sigmars = 715;
ys0 = 100.0;
epe = 0.0;
dispmax = 0.0007;
ds = 0.00001;
young = 15.0;
poisson = 0.29;
C_k = 129.24;
gamma_k = 100.0;
width = 0.1;
height = 0.1;
thickness = 0.01;

void_size = width/resolution;
cutoff = 0.8;

model.param.set('disp', [num2str(disp,'%.2f') '' '[m]'], 'prescribed displacement');
model.param.set('zeta', num2str(zeta,'%.2f'), 'hardening law parameter');
model.param.set('H', [num2str(H,'%.2f') '' '[MPa]'], 'hardening law parameter');
model.param.set('sigmars', [num2str(sigmars,'%.2f') '' '[MPa]'], 'hardening law parameter');
model.param.set('ys0', [num2str(ys0,'%.2f') '' '[MPa]'], 'Initial yield stress');
model.param.set('epe', [num2str(epe,'%.2f') '' '[m]'], 'strain');
model.param.set('dispmax', [num2str(dispmax,'%.4f') '' '[m]'], 'maximum displacement');
model.param.set('ds', [num2str(ds,'%.5f') '' '[m]'], 'prescribed displacement step');
model.param.set('young', [num2str(young,'%.2f') '' '[GPa]'], 'young''s modulus');
model.param.set('poisson', num2str(poisson,'%.2f'), 'poisson''s modulus');
model.param.set('width', [num2str(width,'%.2f') '' '[m]'], 'specimen width');
model.param.set('height',  [num2str(height,'%.2f') '' '[m]'], 'speciment hieght');
model.param.set('thickness', [num2str(thickness,'%.2f') '' '[m]'], 'specimen thickness');
model.param.set('C_k', [num2str(C_k,'%.2f') '' '[MPa]']);
model.param.set('gamma_k', num2str(gamma_k,'%.2f'));

model.component.create('comp1', true);
model.component('comp1').geom.create('geom1', 2);
model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('sq', 'Rectangle');
model.component('comp1').geom('geom1').feature('sq').set('size', [width height]);
model.component('comp1').geom('geom1').feature('sq').set('base', 'center');
model.component('comp1').geom('geom1').feature('sq').set('pos', [0 0]);
model.component('comp1').geom('geom1').run('sq');
model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').set('size', [void_size void_size]);
model.component('comp1').geom('geom1').feature('r1').set('base', 'center');
model.component('comp1').geom('geom1').feature('r1').set('pos', [width/4 0]);
model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').set('size', [void_size void_size]);
model.component('comp1').geom('geom1').feature('r2').set('base', 'center');
model.component('comp1').geom('geom1').feature('r2').set('pos', [0 height/4]);
model.component('comp1').geom('geom1').run('r2');
model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'sq'});
model.component('comp1').geom('geom1').feature('dif1').selection('input2').set({'r1' 'r2'});
model.component('comp1').geom('geom1').run('dif1');
model.component('comp1').geom('geom1').run;

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat1').propertyGroup.create('Murnaghan', 'Murnaghan');
model.component('comp1').material('mat1').propertyGroup.create('Lame', ['Lam' native2unicode(hex2dec({'00' 'e9'}), 'unicode') ' parameters']);
model.component('comp1').material('mat1').label('Structural steel');
model.component('comp1').material('mat1').set('family', 'custom');
model.component('comp1').material('mat1').set('specular', 'custom');
model.component('comp1').material('mat1').set('customspecular', [0.7843137254901961 0.7843137254901961 0.7843137254901961]);
model.component('comp1').material('mat1').set('diffuse', 'custom');
model.component('comp1').material('mat1').set('customdiffuse', [0.6666666666666666 0.6666666666666666 0.6666666666666666]);
model.component('comp1').material('mat1').set('ambient', 'custom');
model.component('comp1').material('mat1').set('customambient', [0.6666666666666666 0.6666666666666666 0.6666666666666666]);
model.component('comp1').material('mat1').set('noise', true);
model.component('comp1').material('mat1').set('noisefreq', 1);
model.component('comp1').material('mat1').set('lighting', 'cooktorrance');
model.component('comp1').material('mat1').set('fresnel', 0.9);
model.component('comp1').material('mat1').set('roughness', 0.3);
model.component('comp1').material('mat1').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').descr('relpermeability_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', '475[J/(kg*K)]');
model.component('comp1').material('mat1').propertyGroup('def').descr('heatcapacity_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'44.5[W/(m*K)]' '0' '0' '0' '44.5[W/(m*K)]' '0' '0' '0' '44.5[W/(m*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').descr('thermalconductivity_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'4.032e6[S/m]' '0' '0' '0' '4.032e6[S/m]' '0' '0' '0' '4.032e6[S/m]'});
model.component('comp1').material('mat1').propertyGroup('def').descr('electricconductivity_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').descr('relpermittivity_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalexpansioncoefficient', {'12.3e-6[1/K]' '0' '0' '0' '12.3e-6[1/K]' '0' '0' '0' '12.3e-6[1/K]'});
model.component('comp1').material('mat1').propertyGroup('def').descr('thermalexpansioncoefficient_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('density', '7850[kg/m^3]');
model.component('comp1').material('mat1').propertyGroup('def').descr('density_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Enu').set('youngsmodulus', '200e9[Pa]');
model.component('comp1').material('mat1').propertyGroup('Enu').descr('youngsmodulus_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Enu').set('poissonsratio', '0.30');
model.component('comp1').material('mat1').propertyGroup('Enu').descr('poissonsratio_symmetry', '');
model.component('comp1').material('mat1').set('groups', {});
model.component('comp1').material('mat1').set('family', 'custom');
model.component('comp1').material('mat1').set('lighting', 'cooktorrance');
model.component('comp1').material('mat1').set('fresnel', 0.9);
model.component('comp1').material('mat1').set('roughness', 0.3);
model.component('comp1').material('mat1').set('ambient', 'custom');
model.component('comp1').material('mat1').set('customambient', [0.6666666666666666 0.6666666666666666 0.6666666666666666]);
model.component('comp1').material('mat1').set('diffuse', 'custom');
model.component('comp1').material('mat1').set('customdiffuse', [0.6666666666666666 0.6666666666666666 0.6666666666666666]);
model.component('comp1').material('mat1').set('specular', 'custom');
model.component('comp1').material('mat1').set('customspecular', [0.7843137254901961 0.7843137254901961 0.7843137254901961]);
model.component('comp1').material('mat1').set('noisescale', 0);
model.component('comp1').material('mat1').set('noise', 'on');
model.component('comp1').material('mat1').set('noisefreq', 1);
model.component('comp1').material('mat1').set('noise', 'on');
model.component('comp1').material('mat1').set('alpha', 1);
model.component('comp1').material('mat1').propertyGroup('Enu').set('youngsmodulus', {'young'});
model.component('comp1').material('mat1').propertyGroup('Enu').set('poissonsratio', {'poisson'});
model.component('comp1').material('mat1').propertyGroup.create('ArmstrongFrederick', 'Armstrong-Frederick');
model.component('comp1').material('mat1').propertyGroup.create('ElastoplasticModel', 'Elastoplastic material model');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func.create('an1', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('funcname', 'sig_h');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+(sigmars-ys0)*(1-exp(-zeta*epe))');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('args', 'epe');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('argunit', '1');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('fununit', 'Pa');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmags', {'ys0'});
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmagh', {'sig_h(epe)'});

model.component('comp1').physics.create('solid', 'SolidMechanics', 'geom1');
model.component('comp1').physics('solid').create('disp1', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp1').label('Prescribed Displacement Top');
model.component('comp1').physics('solid').feature('disp1').selection.set([3]);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-disp', 1);
model.component('comp1').physics('solid').create('disp2', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp2').label('Prescribed Displacement Bottom');
model.component('comp1').physics('solid').feature('disp2').selection.set([2]);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('lemm1').create('plsty1', 'Plasticity', 2);
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('IsotropicHardeningModel', 'UserDefinedIsotropicHardening');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('KinematicHardeningModel', 'Chaboche');

model.component('comp1').material('mat1').propertyGroup('ArmstrongFrederick').set('Ck', {'Ck'});
model.component('comp1').material('mat1').propertyGroup('ArmstrongFrederick').set('Ck', {'C_k'});
model.component('comp1').material('mat1').propertyGroup('ArmstrongFrederick').set('gammak', {'gamma_k'});

model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('KinematicHardeningModel', 'ArmstrongFrederick');

model.component('comp1').mesh('mesh1').create('fq1', 'FreeQuad');
model.component('comp1').mesh('mesh1').feature('size').set('hauto', 4);
model.component('comp1').mesh('mesh1').run;

model.component('comp1').geom('geom1').run('dif1');
model.component('comp1').geom('geom1').create('pt1', 'Point');
model.component('comp1').geom('geom1').feature('pt1').setIndex('p', 'height/2', 1);
model.component('comp1').geom('geom1').run('pt1');
model.component('comp1').geom('geom1').run;

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').feature('stat').activate('solid', true);
model.study('std1').feature('stat').set('useparam', true);
model.study('std1').feature('stat').setIndex('pname', 'disp', 0);
model.study('std1').feature('stat').setIndex('plistarr', '', 0);
model.study('std1').feature('stat').setIndex('punit', 'm', 0);
model.study('std1').feature('stat').setIndex('pname', 'disp', 0);
model.study('std1').feature('stat').setIndex('plistarr', '', 0);
model.study('std1').feature('stat').setIndex('punit', 'm', 0);
model.study('std1').feature('stat').setIndex('plistarr', 'range(0,ds,dispmax)', 0);
model.study('std1').feature('stat').setIndex('punit', 'm', 0);

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

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg1').label('Stress (solid)');
model.result('pg1').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('surf1').create('def', 'Deform');
model.result('pg1').feature('surf1').feature('def').set('expr', {'u' 'v'});
model.result('pg1').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg1').create('con1', 'Contour');
model.result('pg1').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg1').feature('con1').create('def', 'Deform');
model.result('pg1').feature('con1').feature('def').set('expr', {'u' 'v'});
model.result('pg1').feature('con1').feature('def').set('descr', 'Displacement field');
model.result('pg1').feature('con1').set('inheritplot', 'surf1');
model.result('pg1').feature('con1').set('inheritcolor', false);
model.result('pg1').feature('con1').set('inheritrange', false);
model.result('pg1').feature('con1').set('number', 10);
model.result('pg1').feature('con1').set('colortable', 'Twilight');
model.result('pg1').feature('con1').set('descractive', true);
model.result('pg1').feature('con1').set('descr', 'Effective plastic strain');
model.result('pg1').feature('con1').label('Plastic strain');
model.result('pg1').set('legendpos', 'rightdouble');
model.result('pg1').run;

model.result.create('pg2', 'PlotGroup1D');
model.result('pg2').run;
model.result('pg2').label('Stre');
model.result('pg2').label('1D Plot Group 2');
model.result('pg2').create('ptgr1', 'PointGraph');
model.result('pg2').feature('ptgr1').label('Stress x Strain');
model.result('pg2').feature('ptgr1').set('data', 'dset1');
model.result('pg2').feature('ptgr1').selection.set([5]);
model.result('pg2').feature('ptgr1').set('expr', '-solid.RFy/(width*thickness)');
model.result('pg2').feature('ptgr1').set('unit', 'N/m^2');
model.result('pg2').feature('ptgr1').set('descr', 'Stress');
model.result('pg2').feature('ptgr1').set('xdata', 'expr');
model.result('pg2').feature('ptgr1').set('xdataexpr', 'disp/height');
model.result('pg2').feature('ptgr1').set('xdatadescractive', false);
model.result('pg2').feature('ptgr1').set('xdatadescr', 'Strain');
model.result('pg2').feature('ptgr1').set('titletype', 'manual');
model.result('pg2').feature('ptgr1').set('title', 'Strain x Stress');
model.result('pg2').run;

model.sol('sol1').runAll;

out = model;

simulation_name = 'simulation_test';
mphsave(model,simulation_name);

strain = mphinterp(model,'disp/height','coord',[0;height/2],'dataset','dset1');
stress = mphinterp(model,'-solid.RFy/(width*thickness)','coord',[0;height/2],'dataset','dset1');

p = polyfit(strain,stress,1);
E = p(1);
end

