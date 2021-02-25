function out = model
%
% webinar.m
%
% Model exported on Feb 24 2021, 17:27 by COMSOL 5.5.0.292.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath(['C:\Users\lucas\Documents\Github\INT\Manufatura Aditiva\Simula' native2unicode(hex2dec({'00' 'e7'}), 'unicode')  native2unicode(hex2dec({'00' 'e3'}), 'unicode') 'o-GAN\COMSOL-Matlab']);

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('pol1', 'Polygon');
model.component('comp1').geom('geom1').feature('pol1').set('type', 'open');
model.component('comp1').geom('geom1').feature('pol1').set('source', 'table');
model.component('comp1').geom('geom1').feature('pol1').set('table', [-0.5 0.6; 0.4 0; -0.5 -0.6]);
model.component('comp1').geom('geom1').run('pol1');

model.component('comp1').physics.create('truss', 'Truss', 'geom1');

model.component('comp1').geom('geom1').run;

model.component('comp1').physics('truss').create('pin1', 'Pinned', 0);
model.component('comp1').physics('truss').feature('pin1').selection.set([1 2]);

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
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('l', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('m', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('n', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('l', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('m', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('n', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('l', '-3.0e11[Pa]');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('m', '-6.2e11[Pa]');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('n', '-7.2e11[Pa]');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').descr('l_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').descr('m_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').descr('n_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('lambLame', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('muLame', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('lambLame', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('muLame', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('lambLame', '1.15e11[Pa]');
model.component('comp1').material('mat1').propertyGroup('Lame').set('muLame', '7.69e10[Pa]');
model.component('comp1').material('mat1').propertyGroup('Lame').descr('lambLame_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Lame').descr('muLame_symmetry', '');
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
model.component('comp1').material.create('mat2', 'Common');
model.component('comp1').material('mat2').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat2').propertyGroup.create('Murnaghan', 'Murnaghan');
model.component('comp1').material('mat2').propertyGroup.create('Lame', ['Lam' native2unicode(hex2dec({'00' 'e9'}), 'unicode') ' parameters']);
model.component('comp1').material('mat2').label('Structural steel 1');
model.component('comp1').material('mat2').set('family', 'custom');
model.component('comp1').material('mat2').set('specular', 'custom');
model.component('comp1').material('mat2').set('customspecular', [0.7843137254901961 0.7843137254901961 0.7843137254901961]);
model.component('comp1').material('mat2').set('diffuse', 'custom');
model.component('comp1').material('mat2').set('customdiffuse', [0.6666666666666666 0.6666666666666666 0.6666666666666666]);
model.component('comp1').material('mat2').set('ambient', 'custom');
model.component('comp1').material('mat2').set('customambient', [0.6666666666666666 0.6666666666666666 0.6666666666666666]);
model.component('comp1').material('mat2').set('noise', true);
model.component('comp1').material('mat2').set('noisefreq', 1);
model.component('comp1').material('mat2').set('lighting', 'cooktorrance');
model.component('comp1').material('mat2').set('fresnel', 0.9);
model.component('comp1').material('mat2').set('roughness', 0.3);
model.component('comp1').material('mat2').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat2').propertyGroup('def').descr('relpermeability_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('def').set('heatcapacity', '475[J/(kg*K)]');
model.component('comp1').material('mat2').propertyGroup('def').descr('heatcapacity_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('def').set('thermalconductivity', {'44.5[W/(m*K)]' '0' '0' '0' '44.5[W/(m*K)]' '0' '0' '0' '44.5[W/(m*K)]'});
model.component('comp1').material('mat2').propertyGroup('def').descr('thermalconductivity_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('def').set('electricconductivity', {'4.032e6[S/m]' '0' '0' '0' '4.032e6[S/m]' '0' '0' '0' '4.032e6[S/m]'});
model.component('comp1').material('mat2').propertyGroup('def').descr('electricconductivity_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat2').propertyGroup('def').descr('relpermittivity_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('def').set('thermalexpansioncoefficient', {'12.3e-6[1/K]' '0' '0' '0' '12.3e-6[1/K]' '0' '0' '0' '12.3e-6[1/K]'});
model.component('comp1').material('mat2').propertyGroup('def').descr('thermalexpansioncoefficient_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('def').set('density', '7850[kg/m^3]');
model.component('comp1').material('mat2').propertyGroup('def').descr('density_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('Enu').set('youngsmodulus', '200e9[Pa]');
model.component('comp1').material('mat2').propertyGroup('Enu').descr('youngsmodulus_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('Enu').set('poissonsratio', '0.30');
model.component('comp1').material('mat2').propertyGroup('Enu').descr('poissonsratio_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').set('l', '');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').set('m', '');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').set('n', '');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').set('l', '');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').set('m', '');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').set('n', '');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').set('l', '-3.0e11[Pa]');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').set('m', '-6.2e11[Pa]');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').set('n', '-7.2e11[Pa]');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').descr('l_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').descr('m_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('Murnaghan').descr('n_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('Lame').set('lambLame', '');
model.component('comp1').material('mat2').propertyGroup('Lame').set('muLame', '');
model.component('comp1').material('mat2').propertyGroup('Lame').set('lambLame', '');
model.component('comp1').material('mat2').propertyGroup('Lame').set('muLame', '');
model.component('comp1').material('mat2').propertyGroup('Lame').set('lambLame', '1.15e11[Pa]');
model.component('comp1').material('mat2').propertyGroup('Lame').set('muLame', '7.69e10[Pa]');
model.component('comp1').material('mat2').propertyGroup('Lame').descr('lambLame_symmetry', '');
model.component('comp1').material('mat2').propertyGroup('Lame').descr('muLame_symmetry', '');
model.component('comp1').material('mat2').set('groups', {});
model.component('comp1').material('mat2').set('family', 'custom');
model.component('comp1').material('mat2').set('lighting', 'cooktorrance');
model.component('comp1').material('mat2').set('fresnel', 0.9);
model.component('comp1').material('mat2').set('roughness', 0.3);
model.component('comp1').material('mat2').set('ambient', 'custom');
model.component('comp1').material('mat2').set('customambient', [0.6666666666666666 0.6666666666666666 0.6666666666666666]);
model.component('comp1').material('mat2').set('diffuse', 'custom');
model.component('comp1').material('mat2').set('customdiffuse', [0.6666666666666666 0.6666666666666666 0.6666666666666666]);
model.component('comp1').material('mat2').set('specular', 'custom');
model.component('comp1').material('mat2').set('customspecular', [0.7843137254901961 0.7843137254901961 0.7843137254901961]);
model.component('comp1').material('mat2').set('noisescale', 0);
model.component('comp1').material('mat2').set('noise', 'on');
model.component('comp1').material('mat2').set('noisefreq', 1);
model.component('comp1').material('mat2').set('noise', 'on');
model.component('comp1').material('mat2').set('alpha', 1);
model.component('comp1').material.remove('mat2');

model.study.create('std1');
model.study('std1').create('freq', 'Frequency');
model.study('std1').feature('freq').activate('truss', true);
model.study.create('std2');
model.study('std2').create('stat', 'Stationary');
model.study('std2').feature('stat').activate('truss', true);
model.study('std1').feature.remove('freq');
model.study('std1').feature.copy('stat', 'std2/stat');
model.study('std2').feature.remove('stat');
model.study.remove('std2');

model.component('comp1').physics('truss').create('disp1', 'Displacement0', 0);
model.component('comp1').physics('truss').feature('disp1').setIndex('Direction', true, 0);
model.component('comp1').physics('truss').feature('disp1').setIndex('U0', 'dispx', 0);

model.param.set('dispx', '2[mm]');

model.component('comp1').physics('truss').feature('disp1').setIndex('Direction', true, 1);

model.study('std1').feature('stat').set('useparam', true);
model.study('std1').feature('stat').setIndex('pname', 'dispx', 0);
model.study('std1').feature('stat').setIndex('plistarr', '', 0);
model.study('std1').feature('stat').setIndex('punit', 'm', 0);
model.study('std1').feature('stat').setIndex('pname', 'dispx', 0);
model.study('std1').feature('stat').setIndex('plistarr', '', 0);
model.study('std1').feature('stat').setIndex('punit', 'm', 0);
model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.1,2)', 0);
model.study('std1').feature('stat').setIndex('punit', 'mm', 0);

model.component('comp1').physics('truss').feature('disp1').selection.set([3]);

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
model.sol('sol1').feature('s1').feature('p1').set('control', 'stat');
model.sol('sol1').feature('s1').set('control', 'stat');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'dDef');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('line1', 'Line');
model.result('pg1').feature('line1').set('expr', {'truss.Nxl'});
model.result('pg1').label('Force (truss)');
model.result('pg1').feature('line1').set('colortable', 'Wave');
model.result('pg1').feature('line1').set('resolution', 'extrafine');
model.result('pg1').feature('line1').set('smooth', 'internal');
model.result('pg1').feature('line1').set('linetype', 'tube');
model.result('pg1').feature('line1').set('radiusexpr', 'truss.re');
model.result('pg1').feature('line1').set('tuberadiusscaleactive', true);
model.result('pg1').feature('line1').set('tuberadiusscale', 1);
model.result('pg1').feature('line1').create('def', 'Deform');
model.result('pg1').feature('line1').feature('def').set('expr', {'u' 'v'});
model.result('pg1').feature('line1').feature('def').set('descr', 'Displacement field');
model.result.create('pg2', 'PlotGroup2D');
model.result('pg2').set('data', 'dset1');
model.result('pg2').create('line1', 'Line');
model.result('pg2').feature('line1').set('expr', {'truss.sn'});
model.result('pg2').label('Stress (truss)');
model.result('pg2').feature('line1').set('colortable', 'RainbowLight');
model.result('pg2').feature('line1').set('resolution', 'extrafine');
model.result('pg2').feature('line1').set('smooth', 'internal');
model.result('pg2').feature('line1').set('linetype', 'tube');
model.result('pg2').feature('line1').set('radiusexpr', 'truss.re');
model.result('pg2').feature('line1').set('tuberadiusscaleactive', true);
model.result('pg2').feature('line1').set('tuberadiusscale', 1);
model.result('pg2').feature('line1').create('def', 'Deform');
model.result('pg2').feature('line1').feature('def').set('expr', {'u' 'v'});
model.result('pg2').feature('line1').feature('def').set('descr', 'Displacement field');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result.create('pg3', 'PlotGroup1D');
model.result('pg3').run;
model.result('pg3').setIndex('looplevelinput', 'manualindices', 0);
model.result('pg3').setIndex('looplevelinput', 'all', 0);
model.result('pg3').create('ptgr1', 'PointGraph');
model.result('pg3').feature('ptgr1').selection.set([3]);
model.result('pg3').feature('ptgr1').set('unit', 'mm');
model.result('pg3').feature('ptgr1').set('xdata', 'solution');
model.result('pg3').feature('ptgr1').set('expr', 'truss.RFx');
model.result('pg3').feature('ptgr1').set('xdata', 'expr');
model.result('pg3').feature('ptgr1').set('xdataexpr', 'u');
model.result('pg3').feature('ptgr1').set('xdataunit', 'mm');
model.result('pg3').run;

model.component('comp1').physics('truss').feature('emm1').create('plsty1', 'Plasticity', 1);
model.component('comp1').physics('truss').feature('emm1').feature('plsty1').set('IsotropicHardeningModel', 'PerfectlyPlastic');

model.component('comp1').material('mat1').propertyGroup.create('ElastoplasticModel', 'Elastoplastic material model');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmags', {'200[MPa]'});

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('control', 'stat');
model.sol('sol1').feature('s1').set('control', 'stat');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'dDef');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').run;

model.component('comp1').physics('truss').feature('emm1').feature('plsty1').selection.set([2]);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('control', 'stat');
model.sol('sol1').feature('s1').set('control', 'stat');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'dDef');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').run;

model.component('comp1').physics('truss').feature('emm1').feature('plsty1').selection.set([1 2]);

model.component('comp1').material.duplicate('mat2', 'mat1');
model.component('comp1').material('mat2').selection.set([1]);
model.component('comp1').material('mat1').selection.set([2]);
model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').set('sigmags', {'250[MPa]'});

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('control', 'stat');
model.sol('sol1').feature('s1').set('control', 'stat');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'dDef');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').run;

model.component('comp1').geom('geom1').feature.remove('pol1');
model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').run;

model.component('comp1').physics.remove('truss');

model.component('comp1').geom('geom1').feature('r1').set('size', [1 10]);
model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').feature('r1').set('size', [2 10]);
model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').create('csol1', 'ConvertToSolid');
model.component('comp1').geom('geom1').feature('csol1').selection('input').set({'r1'});
model.component('comp1').geom('geom1').feature.remove('csol1');

model.component('comp1').physics.create('solid', 'SolidMechanics', 'geom1');

model.study('std1').feature('stat').activate('solid', true);

model.component('comp1').geom('geom1').run;

model.component('comp1').material.remove('mat2');
model.component('comp1').material('mat1').propertyGroup('Enu').set('youngsmodulus', {'206.9[GPa]'});
model.component('comp1').material('mat1').propertyGroup('Enu').set('poissonsratio', {'0.29'});
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmags', {'450[MPa]'});

model.component('comp1').physics('solid').feature('lemm1').create('plsty1', 'Plasticity', 2);
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('KinematicHardeningModel', 'ArmstrongFrederick');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('IsotropicHardeningModel', 'UserDefinedIsotropicHardening');

model.component('comp1').material('mat1').propertyGroup.create('pg1', 'User-defined property group');
model.component('comp1').material('mat1').propertyGroup('def').active(false);
model.component('comp1').material('mat1').propertyGroup('Enu').active(false);
model.component('comp1').material('mat1').propertyGroup('Murnaghan').active(false);
model.component('comp1').material('mat1').propertyGroup('Lame').active(false);
model.component('comp1').material('mat1').propertyGroup('pg1').active(false);
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func.create('an1', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('funcname', 'sig_h');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+(sigmaSF-sigma0)*(1-exp(-zetaa*epe))');

model.study('std1').feature('stat').setIndex('pname', '', 0);
model.study('std1').feature('stat').setIndex('pname', 'dispx', 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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

model.label('webinar.mph');

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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

model.component('comp1').material('mat1').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat1').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat1').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat1').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');

model.component('comp1').physics('solid').feature('lemm1').set('SolidModel', 'Orthotropic');

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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

model.param.set('zeta', '16.93');
model.param.set('H', '129.24[MPa]');
model.param.set('sigmars', '715[MPa]');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+(sigmars-sigmags)*(1-exp(-zeta*epe))');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('args', 'epe');

model.component('comp1').geom('geom1').run('fin');

model.component('comp1').mesh('mesh1').run;

model.component('comp1').material('mat1').selection.set([1 2 3 4]);
model.component('comp1').material('mat1').selection.geom('geom1', 2);
model.component('comp1').material('mat1').selection.set([1]);
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+(sigmars-sigmags)*(1-exp(-zeta*epe))');

model.param.set('sigmags', '450[MPa]');

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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

model.component('comp1').material('mat1').propertyGroup('Enu').active(true);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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

model.component('comp1').material('mat1').propertyGroup('def').active(true);
model.component('comp1').material('mat1').propertyGroup.create('ArmstrongFrederick', 'Armstrong-Frederick');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmagh', {'sigma_h'});
model.component('comp1').material('mat1').propertyGroup('ArmstrongFrederick').set('Ck', {'129.24[MPa]'});

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmagh', {});

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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

model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh_mat', 'from_mat');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmagh', {'sig_h(epe)'});

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmagh', {'sig_h'});
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('argunit', '1');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('fununit', 'Pa');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmagh', {'sig_h(epe)'});

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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

model.param.set('epe', '0[mm]');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').addInput('displacement');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').removeInput('displacement');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').addInput('effectiveplasticstrain');

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.component('comp1').material('mat1').propertyGroup.remove('Murnaghan');
model.component('comp1').material('mat1').propertyGroup.remove('Lame');
model.component('comp1').material('mat1').propertyGroup.remove('pg1');

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg2').active(false);
model.result('pg2').run;
model.result.remove('pg2');
model.result('pg1').run;
model.result.remove('pg1');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature.remove('ptgr1');
model.result('pg3').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').create('ptgr1', 'PointGraph');
model.result('pg3').feature('ptgr1').label('Stress x Strain');
model.result('pg3').feature('ptgr1').set('data', 'dset1');
model.result('pg3').feature('ptgr1').selection.all;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdata', 'expr');
model.result('pg3').feature('ptgr1').set('expr', '');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1x');
model.result('pg3').feature('ptgr1').set('descr', 'Principal stress direction 1, x component');
model.result('pg3').run;
model.result.create('pg4', 'PlotGroup3D');
model.result('pg4').run;
model.result('pg3').run;
model.result('pg4').run;
model.result.remove('pg4');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.set([]);
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1z');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1x');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2x');
model.result('pg3').feature('ptgr1').set('descr', 'Principal stress direction 2, x component');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2z');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp3x');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp3y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp3z');
model.result('pg3').run;

model.component('comp1').physics('solid').create('disp1', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp1').selection.set([3]);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', 'dispy', 1);

model.param.remove('dispx');
model.param.set('dispx', '0.0[mm]');

model.component('comp1').physics('solid').feature('disp1').label('Prescribed Displacement Top');
model.component('comp1').physics('solid').create('fix1', 'Fixed', 1);
model.component('comp1').physics('solid').feature('fix1').selection.set([2]);
model.component('comp1').physics('solid').feature('fix1').label('Fixed Bottom');

model.param.rename('dispx', 'dispy');

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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

model.study('std1').feature('stat').setIndex('pname', 'dispy', 0);
model.study('std1').feature('stat').setIndex('plistarr', '', 0);
model.study('std1').feature('stat').setIndex('punit', 'm', 0);
model.study('std1').feature('stat').setIndex('pname', 'dispy', 0);
model.study('std1').feature('stat').setIndex('plistarr', '', 0);
model.study('std1').feature('stat').setIndex('punit', 'm', 0);
model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.1,2)', 0);
model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.1,7)', 0);
model.study('std1').feature('stat').setIndex('punit', 'mm', 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result.create('pg4', 'PlotGroup2D');
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').create('surf1', 'Surface');
model.result('pg4').feature('surf1').set('data', 'dset1');
model.result('pg4').feature('surf1').set('expr', 'solid.sp');
model.result('pg4').feature('surf1').set('unit', 'MPa');
model.result('pg4').feature('surf1').set('expr', 'solid.sp2');
model.result('pg4').feature('surf1').set('descr', 'Second principal stress');
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.set([1 3]);
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp3');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2x');
model.result('pg3').run;

model.component('comp1').physics('solid').feature.remove('fix1');

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;

model.component('comp1').physics('solid').create('disp2', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp2').selection.set([2]);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp2').label('Prescribed Displacement Bottom');
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', false, 1);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').setIndex('looplevel', 10, 0);
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').setIndex('looplevel', 16, 0);
model.result('pg4').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.all;
model.result('pg3').feature('ptgr1').selection.set([]);
model.result('pg3').feature('ptgr1').set('data', 'parent');
model.result('pg3').feature('ptgr1').selection.set([2]);
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp3y');
model.result('pg3').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;

model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-dispy', 1);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2');
model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').feature('surf1').setIndex('looplevel', 59, 0);
model.result('pg4').run;
model.result('pg4').feature('surf1').setIndex('looplevel', 71, 0);
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1x');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').run;

model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', false, 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;

model.component('comp1').physics('solid').create('fix1', 'Fixed', 1);
model.component('comp1').physics('solid').feature('fix1').selection.set([2]);
model.component('comp1').physics('solid').feature('disp2').active(false);
model.component('comp1').physics('solid').feature.remove('disp2');

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.1,4)', 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1y');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp2y');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp2x');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1x');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1y');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp2');
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 1);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature.remove('fix1');
model.component('comp1').physics('solid').create('disp2', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp2').label('Prescribed Displacement Bottom');
model.component('comp1').physics('solid').feature('disp2').selection.set([2]);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1x');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1y');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1z');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp2x');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp2y');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp2');
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp2').setIndex('U0', 'dispy', 1);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1y');
model.result('pg4').run;
model.result('pg4').set('windowtitle', 'Graphics');

model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-epe', 1);
model.component('comp1').physics('solid').feature('disp1').set('Notation', 'StandardNotation');
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', false, 1);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp2').setIndex('U0', 'epe', 1);

model.study('std1').feature('stat').setIndex('pname', 'epe', 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1x');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1y');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp2y');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp2x');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1y');
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.set([4]);

model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', false, 1);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;

model.study('std1').feature('stat').set('sweeptype', 'filled');

model.result.dataset('dset1').set('frametype', 'spatial');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;

model.label('webinar.mph');

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').run;

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.01,10)', 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').run;

model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp2').setIndex('U0', 0, 1);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').mesh('mesh1').autoMeshSize(3);
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').autoMeshSize(2);
model.component('comp1').mesh('mesh1').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.01,20)', 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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

model.component('comp1').material('mat1').propertyGroup('ArmstrongFrederick').set('gammak', {'100'});

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').setIndex('looplevel', 2001, 0);
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').setIndex('looplevel', 1984, 0);
model.result('pg4').run;
model.result('pg4').setIndex('looplevel', 228, 0);
model.result('pg4').run;
model.result('pg4').setIndex('looplevel', 57, 0);
model.result('pg4').run;
model.result('pg4').setIndex('looplevel', 1, 0);
model.result('pg4').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp3y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').feature('ptgr1').set('descr', 'Principal stress direction 1, y component');
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep1Y');
model.result('pg3').feature('ptgr1').set('xdatadescr', 'Principal strain direction 1, Y component');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep2Y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep3Y');
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp3y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp');
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep');
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep1Y');
model.result('pg3').run;

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.01,7)', 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').geom('geom1').feature('r1').set('base', 'center');
model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp1').set('Notation', 'StandardNotation');

model.result('pg4').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.epe');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.set([2 4]);
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.epe1');
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1');
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.epe1Y');
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep1Y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.set([4]);
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.set([2]);
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep2Y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.epe');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.epY');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep2Y');
model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp');
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.epe');
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 1);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-epe', 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', 0, 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp1').set('coordinateSystem', 'sys1');
model.component('comp1').physics('solid').feature('disp2').set('coordinateSystem', 'sys1');

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;

model.label('webinar.mph');

model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.epY');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep2Y');
model.result('pg3').feature('ptgr1').set('xdatadescr', 'Principal strain direction 2, Y component');
model.result('pg3').run;

model.component('comp1').physics('solid').create('epsm1', 'ElastoplasticSoilMaterial', 2);
model.component('comp1').physics('solid').feature('epsm1').selection.set([1]);
model.component('comp1').physics('solid').feature.remove('epsm1');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh_mat', 'from_mat');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmags_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmags', 'sigmags');

model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.mises');
model.result('pg3').feature('ptgr1').set('descr', 'von Mises stress');
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.epe');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep2Y');
model.result('pg3').feature('ptgr1').set('xdatadescr', 'Principal strain direction 2, Y component');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'epe');
model.result('pg3').feature('ptgr1').set('xdataunit', 'mm');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1x');
model.result('pg3').run;

model.component('comp1').physics('solid').feature('disp1').set('Notation', 'StandardNotation');
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-epe/1000', 1);
model.component('comp1').physics('solid').feature('disp2').set('coordinateSystem', 'GlobalSystem');
model.component('comp1').physics('solid').feature('disp1').set('coordinateSystem', 'GlobalSystem');

model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').setIndex('looplevel', 104, 0);
model.result('pg4').run;
model.result('pg4').setIndex('looplevel', 2, 0);
model.result('pg4').run;

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.1,7)', 0);

model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature.remove('disp2');

model.component('comp1').mesh('mesh1').create('fq1', 'FreeQuad');
model.component('comp1').mesh('mesh1').run;

model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmags_mat', 'from_mat');
model.component('comp1').physics('solid').create('fix1', 'Fixed', 1);
model.component('comp1').physics('solid').feature('fix1').selection.set([2]);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.set([1 2 3 4]);
model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').setIndex('looplevel', 11, 0);
model.result('pg4').run;
model.result('pg4').selection.geom('geom1', 1);
model.result('pg4').selection.geom('geom1', 1);
model.result('pg4').selection.set([3]);
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-epe', 1);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', 'epe', 1);
model.component('comp1').physics('solid').feature('disp1').selection.set([]);
model.component('comp1').physics('solid').feature('fix1').selection.set([3]);
model.component('comp1').physics('solid').feature('disp1').selection.set([2]);

model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature.remove('disp1');
model.component('comp1').physics('solid').create('bndl1', 'BoundaryLoad', 1);
model.component('comp1').physics('solid').feature('bndl1').set('FperArea', [0 200 0]);
model.component('comp1').physics('solid').feature('bndl1').selection.set([2]);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature('bndl1').set('FperArea', [0 200000 0]);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature.remove('bndl1');
model.component('comp1').physics('solid').create('disp1', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', 'epe', 1);
model.component('comp1').physics('solid').feature('disp1').selection.set([2]);

model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1');

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.set([]);
model.result('pg3').feature('ptgr1').selection.all;
model.result('pg3').feature('ptgr1').selection.set([2 4]);
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('data', 'dset1');
model.result('pg3').feature('ptgr1').setIndex('looplevelinput', 'manualindices', 0);
model.result('pg3').feature('ptgr1').setIndex('looplevelinput', 'all', 0);
model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').selection.geom('geom1', 1);
model.result('pg4').selection.set([2 3]);
model.result('pg4').selection.geom('geom1');
model.result('pg4').selection.geom('geom1', 2);
model.result('pg4').selection.geom('geom1', 2);
model.result('pg4').selection.set([1]);
model.result('pg4').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;

model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-epe', 1);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;

model.study('std1').feature('stat').set('sweeptype', 'sparse');

model.component('comp1').physics('solid').feature.remove('fix1');
model.component('comp1').physics('solid').create('disp2', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp2').selection.set([2]);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp1').selection.set([3]);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-dispy', 1);

model.study('std1').feature('stat').setIndex('pname', 'dispy', 0);

model.result('pg3').run;
model.result('pg3').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'dispy');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sigmagh');
model.result('pg3').feature('ptgr1').set('descr', 'Hardening function');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp2');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp3');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1y');
model.result('pg3').run;
model.result('pg3').run;

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.01,7)', 0);

model.result('pg4').run;
model.result('pg4').selection.geom('geom1');
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp1').selection.set([1 3 4]);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp1').selection.set([3]);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 1);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-dispy', 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', 0, 0);

model.result('pg3').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.set([2]);
model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').set('showlegends', true);

model.component('comp1').view('view1').set('showgrid', true);

model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp2');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1x');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1y');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1');
model.result('pg4').run;
model.result('pg4').feature('surf1').setIndex('looplevel', 411, 0);
model.result('pg4').feature('surf1').set('data', 'parent');
model.result('pg4').run;
model.result('pg4').feature('surf1').set('data', 'dset1');
model.result('pg4').feature('surf1').setIndex('looplevel', 548, 0);
model.result('pg4').run;
model.result('pg4').feature('surf1').setIndex('looplevel', 5, 0);
model.result('pg4').run;
model.result('pg4').feature('surf1').setIndex('looplevel', 1, 0);
model.result('pg4').run;
model.result('pg4').feature('surf1').setIndex('looplevel', 2, 0);
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.sp1');
model.result('pg4').feature('surf1').set('descr', 'First principal stress');
model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.sp1');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.set([2 4]);
model.result('pg3').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', false, 0);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', false, 1);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').run;

model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 1);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg4').run;

model.label('webinar.mph');

model.result('pg4').run;
model.result('pg4').run;
model.result('pg4').feature('surf1').set('expr', 'solid.mises');
model.result('pg4').feature('surf1').set('descr', 'von Mises stress');
model.result('pg4').run;

model.component('comp1').physics('solid').feature('lemm1').set('SolidModel', 'Isotropic');

model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').create('pt1', 'Point');
model.component('comp1').geom('geom1').run('pt1');
model.component('comp1').geom('geom1').run;

model.component('comp1').mesh('mesh1').run;

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.01,15)', 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').selection.set([3]);
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('expr', 'solid.mises');
model.result('pg3').run;

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.01,7)', 0);
model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.01,25)', 0);

model.sol('sol1').study('std1');

model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
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
model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'v');
model.result('pg3').feature('ptgr1').set('xdatadescr', 'Displacement field, Y component');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;

model.param.set('dispmax', '7');

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.01,dispmax)', 0);

model.param.set('dispmax', '25[mm]');

model.result('pg4').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep1Y');
model.result('pg3').feature('ptgr1').set('xdatadescr', 'Principal strain direction 1, Y component');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep1');
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep1Y');
model.result('pg3').feature('ptgr1').set('xdatadescr', 'Principal strain direction 1, Y component');
model.result('pg3').feature('ptgr1').set('xdataexpr', 'solid.ep1');
model.result('pg3').run;

model.param.set('sigmags', '100[MPa]');

model.sol('sol1').runAll;

model.result('pg3').run;

model.param.set('sigmags', '100[MPa]');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmags', {'100[MPa]'});

model.sol('sol1').runAll;

model.result('pg3').run;

model.param.set('dispmax', '7[mm]');

model.sol('sol1').runAll;

model.result('pg3').run;

model.param.set('dispmax', '20[mm]');

model.sol('sol1').runAll;

model.result('pg3').run;

model.param.rename('sigmags', 'ys0');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmags', {'ys0'});

model.param.set('young', '206[GPa]');

model.component('comp1').material('mat1').propertyGroup('Enu').set('youngsmodulus', {'young'});

model.param.set('young', '200[GPa]');

model.component('comp1').material('mat1').propertyGroup('Enu').set('poissonsratio', {'poisson'});

model.param.set('poisson', '0.29');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+(sigmars-sigmags)*(1-exp(-zeta*epe))');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmags', {'100[MPa]'});
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'sigmags*epe');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmags', {'100[MPa]'});

model.param.rename('ys0', 'sigmags');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+(sigmars-sigmags)*(1-exp(-zeta*epe))');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmags', {'ys0'});

model.param.rename('sigmags', 'ys0');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmags', {'ys0'});
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+(sigmars-ys0)*(1-exp(-zeta*epe))');

model.sol('sol1').runAll;

model.result('pg3').run;

model.component('comp1').physics('solid').feature('disp1').active(false);
model.component('comp1').physics('solid').feature('disp2').active(false);
model.component('comp1').physics('solid').create('disp3', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp3').selection.set([1]);
model.component('comp1').physics('solid').feature('disp3').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp3').setIndex('U0', 'dispy', 0);
model.component('comp1').physics('solid').feature('disp3').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').create('disp4', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp4').label('Prescribed Displacement right');
model.component('comp1').physics('solid').feature('disp4').selection.set([4]);
model.component('comp1').physics('solid').feature('disp4').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp4').setIndex('Direction', true, 1);
model.component('comp1').physics('solid').feature('disp3').label('Prescribed Displacement L');
model.component('comp1').physics('solid').feature('disp4').label('Prescribed Displacement R');

model.sol('sol1').runAll;

model.result('pg3').run;

model.component('comp1').physics('solid').feature('disp3').active(false);
model.component('comp1').physics('solid').feature('disp4').active(false);
model.component('comp1').physics('solid').feature('disp1').active(true);
model.component('comp1').physics('solid').feature('disp2').active(true);

model.sol('sol1').runAll;

model.result('pg3').run;

model.param.set('W', '10');
model.param.rename('W', 'width');
model.param.set('height', '10');
model.param.set('width', '10[mm]');
model.param.set('height', '10[mm]');

model.component('comp1').geom('geom1').feature('r1').set('size', {'width' 'height'});
model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').run('r1');

model.param.set('width', '10[cm]');
model.param.set('height', '10[cm]');

model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').feature('r1').set('size', {'2' 'height'});
model.component('comp1').geom('geom1').feature('r1').set('size', [2 10]);
model.component('comp1').geom('geom1').run('r1');

model.sol('sol1').runAll;

model.result('pg3').run;

model.component('comp1').geom('geom1').feature('r1').set('size', [10 10]);
model.component('comp1').geom('geom1').run('r1');

model.sol('sol1').runAll;

model.result('pg3').run;

model.component('comp1').physics('solid').feature('disp1').label('Prescribed Displacement Top');
model.component('comp1').physics('solid').feature('disp2').label('Prescribed Displacement Bottom');

model.sol('sol1').runAll;

model.result('pg3').run;

model.component('comp1').physics('solid').feature('disp1').active(false);
model.component('comp1').physics('solid').feature('disp2').active(false);
model.component('comp1').physics('solid').feature('disp3').active(true);
model.component('comp1').physics('solid').feature('disp4').active(true);

model.sol('sol1').runAll;

model.result('pg3').run;

model.component('comp1').geom('geom1').feature('r1').set('size', {'10[cm]' '10[cm]'});
model.component('comp1').geom('geom1').feature('r1').setIndex('sizeconstr', true, 0);
model.component('comp1').geom('geom1').feature('r1').setIndex('sizeconstr', false, 0);
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').feature('r1').set('size', {'2[cm]' '10[cm]'});
model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').feature('r1').set('size', {'10[cm]' '10[cm]'});
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').physics('solid').feature('disp1').active(true);
model.component('comp1').physics('solid').feature('disp2').active(true);
model.component('comp1').physics('solid').feature('disp3').active(false);
model.component('comp1').physics('solid').feature('disp4').active(false);

model.component('comp1').geom('geom1').feature('r1').set('size', {'width' 'height'});

model.param.set('width', '100[cm]');
model.param.set('height', '100[cm]');

model.component('comp1').geom('geom1').run;

model.sol('sol1').runAll;

model.result('pg3').run;

model.param.set('width', '10[cm]');
model.param.set('height', '10[cm]');
model.param.descr('dispy', 'prescribed displacement');
model.param.descr('zeta', 'hardening law parameter');
model.param.descr('H', 'hardening law parameter');
model.param.descr('sigmars', 'hardening law parameter');
model.param.descr('ys0', 'Initial yield stress');
model.param.descr('epe', 'displacement');
model.param.descr('epe', 'strain');
model.param.descr('dispmax', 'maximum displacement');
model.param.descr('young', 'young''s modulus');
model.param.descr('poisson', 'poisson''s modulus');
model.param.descr('width', 'specimen width');
model.param.descr('height', 'speciment hieght');
model.param.set('dispmax', '2[mm]');

model.sol('sol1').runAll;

model.result('pg3').run;

model.param.set('dispmax', '10[mm]');

model.sol('sol1').runAll;

model.result('pg3').run;

model.param.set('dispmax', '20[mm]');
model.param.set('width', '100[cm]');
model.param.set('height', '100[cm]');

model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;

model.param.set('width', '10[cm]');
model.param.set('height', '10[cm]');

model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').run('fin');

model.result('pg4').run;
model.result('pg3').run;

model.param.set('dispmax', '2[mm]');

model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('ptgr1').set('xdataexpr', 'dispy');
model.result('pg3').feature('ptgr1').set('xdatadescr', 'prescribed displacement');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;

model.param.set('dispmax', '10[mm]');

model.sol('sol1').runAll;

model.result('pg3').run;

model.param.set('dispmax', '15[mm]');

model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;

model.param.set('dispmax', '18[mm]');

model.sol('sol1').runAll;

model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;

model.param.set('dispmax', '19[mm]');

model.sol('sol1').runAll;

model.result('pg3').run;

model.param.set('width', '100[cm]');
model.param.set('height', '1000[cm]');
model.param.set('width', '1000[cm]');

model.component('comp1').geom('geom1').run;

model.param.set('dispmax', '20[mm]');

model.sol('sol1').runAll;

model.result('pg3').run;

model.param.set('width', '10[cm]');
model.param.set('height', '10[cm]');
model.param.set('width', '100[cm]');
model.param.set('height', '100[cm]');
model.param.set('width', '10[m]');
model.param.set('height', '10[m]');

model.component('comp1').geom('geom1').run;

model.sol('sol1').runAll;

model.result('pg3').run;

out = model;
