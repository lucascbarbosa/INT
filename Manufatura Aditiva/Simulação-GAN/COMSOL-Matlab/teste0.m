function out = model
%
% teste0.m
%
% Model exported on Dec 5 2020, 00:31 by COMSOL 5.5.0.359.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('C:\Users\lucas\Downloads');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);
model.component('comp1').geom('geom1').axisymmetric(true);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('r1', 'Rectangle');

model.param.set('h', '30[mm]');
model.param.set('r', '6[mm]');

model.component('comp1').geom('geom1').feature('r1').set('size', {'r' 'h'});
model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').run;

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').label('Minlon 12T [DAM, 0.2% moisture content]');
model.component('comp1').material('mat1').info.create('Composition');
model.component('comp1').material('mat1').info('Composition').body('36% mineral reinforced, toughened, heat stabilized, nylon 66');
model.component('comp1').material('mat1').propertyGroup('def').set('Syt', 'Syt_DAM_0_2_moisture_content_1(T[1/K])[Pa]');
model.component('comp1').material('mat1').propertyGroup('def').set('elong', 'elong_DAM_0_2_moisture_content_1(T[1/K])');
model.component('comp1').material('mat1').propertyGroup('def').set('FM', 'FM_DAM_0_2_moisture_content_1(T[1/K])[Pa]');
model.component('comp1').material('mat1').propertyGroup('def').func.create('Syt_DAM_0_2_moisture_content_1', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func('Syt_DAM_0_2_moisture_content_1').set('funcname', 'Syt_DAM_0_2_moisture_content_1');
model.component('comp1').material('mat1').propertyGroup('def').func('Syt_DAM_0_2_moisture_content_1').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('Syt_DAM_0_2_moisture_content_1').set('extrap', 'constant');
model.component('comp1').material('mat1').propertyGroup('def').func('Syt_DAM_0_2_moisture_content_1').set('pieces', {'233.0' '394.0' '4.246462E8-1740265.0*T^1+1932.064*T^2'});
model.component('comp1').material('mat1').propertyGroup('def').func('Syt_DAM_0_2_moisture_content_1').label('Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func('Syt_DAM_0_2_moisture_content_1').set('fununit', '');
model.component('comp1').material('mat1').propertyGroup('def').func('Syt_DAM_0_2_moisture_content_1').set('argunit', '');
model.component('comp1').material('mat1').propertyGroup('def').func.create('elong_DAM_0_2_moisture_content_1', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func('elong_DAM_0_2_moisture_content_1').set('funcname', 'elong_DAM_0_2_moisture_content_1');
model.component('comp1').material('mat1').propertyGroup('def').func('elong_DAM_0_2_moisture_content_1').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('elong_DAM_0_2_moisture_content_1').set('extrap', 'constant');
model.component('comp1').material('mat1').propertyGroup('def').func('elong_DAM_0_2_moisture_content_1').set('pieces', {'233.0' '350.0' '205.2928-1.703545*T^1+0.003640393*T^2'; '350.0' '394.0' '-328.4656+1.624717*T^1-0.001511716*T^2'});
model.component('comp1').material('mat1').propertyGroup('def').func('elong_DAM_0_2_moisture_content_1').label('Piecewise 1');
model.component('comp1').material('mat1').propertyGroup('def').func('elong_DAM_0_2_moisture_content_1').set('fununit', '');
model.component('comp1').material('mat1').propertyGroup('def').func('elong_DAM_0_2_moisture_content_1').set('argunit', '');
model.component('comp1').material('mat1').propertyGroup('def').func.create('FM_DAM_0_2_moisture_content_1', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func('FM_DAM_0_2_moisture_content_1').set('funcname', 'FM_DAM_0_2_moisture_content_1');
model.component('comp1').material('mat1').propertyGroup('def').func('FM_DAM_0_2_moisture_content_1').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('FM_DAM_0_2_moisture_content_1').set('extrap', 'constant');
model.component('comp1').material('mat1').propertyGroup('def').func('FM_DAM_0_2_moisture_content_1').set('pieces', {'233.0' '350.0' '-5.747921E9+1.168028E8*T^1-276669.8*T^2'; '350.0' '394.0' '2.297825E11-1.744404E9*T^1+4444552.0*T^2-3789.106*T^3'});
model.component('comp1').material('mat1').propertyGroup('def').func('FM_DAM_0_2_moisture_content_1').label('Piecewise 2');
model.component('comp1').material('mat1').propertyGroup('def').func('FM_DAM_0_2_moisture_content_1').set('fununit', '');
model.component('comp1').material('mat1').propertyGroup('def').func('FM_DAM_0_2_moisture_content_1').set('argunit', '');
model.component('comp1').material('mat1').propertyGroup('def').addInput('temperature');
model.component('comp1').material('mat1').propertyGroup.create('ElastoplasticModel', 'Elastoplastic material model');

model.component('comp1').physics.create('solid', 'SolidMechanics', 'geom1');
model.component('comp1').physics('solid').feature('lemm1').create('plsty1', 'Plasticity', 2);
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('IsotropicHardeningModel', 'UserDefinedIsotropicHardening');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func.create('an1', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').set('youngsmodulus', {'206.9[GPa]'});
model.component('comp1').material('mat1').propertyGroup('def').set('poissonsratio', {'0.29'});
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmags', {'450[MPa]'});
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').label('H*epe+(sigmaSF');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').label('H*epe+(sigmaSF-sigma');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').label('H*epe+(sigmaSF-sigmags)*(1-zeta');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').label('H*epe+(sigmaSF-sigmags)*(1-exp(-zeta*epe))');

model.param.set('sigmaSF', '725[MPa]');
model.param.set('H', '129.24[MPa]');
model.param.set('zeta', '16.93');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('funcname', 'epe');

model.param.rename('h', 'ho');
model.param.rename('r', 'ro');

model.component('comp1').geom('geom1').feature('r1').set('size', {'ro' 'ho/2'});
model.component('comp1').geom('geom1').run('r1');

model.param.set('ho', '54[mm]');

model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').run;

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').label('(1-exp(-zeta*epe))');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').label('H*epe+(sigmaSF-sigmags)*(1-exp(-zeta*epe))');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('funcname', 'sig');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('args', 'epe');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+(sigmaSF-sigmags)*(1-exp(-zeta*epe))');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('args', 'epe');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('argunit', '1');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('fununit', 'Pa');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').label('Hardening function');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+sigmaSF-sig');

model.param.set('sigma0', '450[MPa]');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+(sigmaSF-sigma0)*(1-exp(-zeta*epe))');

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').feature('stat').activate('solid', true);
model.study('std1').feature('stat').set('useparam', true);
model.study('std1').feature('stat').setIndex('pname', 'ho', 0);
model.study('std1').feature('stat').setIndex('plistarr', '', 0);
model.study('std1').feature('stat').setIndex('punit', 'm', 0);
model.study('std1').feature('stat').setIndex('pname', 'ho', 0);
model.study('std1').feature('stat').setIndex('plistarr', '', 0);
model.study('std1').feature('stat').setIndex('punit', 'm', 0);
model.study('std1').feature('stat').setIndex('pname', '', 0);
model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.1', 0);

model.component('comp1').physics('solid').create('disp1', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp1').label('Prescribed Displacement Top');
model.component('comp1').physics('solid').feature('disp1').selection.set([3]);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 2);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-disp', 2);

model.param.set('disp', '0.5[mm]');

model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 2);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 2);
model.component('comp1').physics('solid').create('disp2', 'Displacement1', 1);
model.component('comp1').physics('solid').feature.remove('disp2');
model.component('comp1').physics('solid').feature('disp1').label('Prescribed Displacement Bottom');
model.component('comp1').physics('solid').feature('disp1').selection.set([2]);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 2);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', 'disp', 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 2);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', 0, 2);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 2);

model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
model.component('comp1').mesh('mesh1').run('ftri1');

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.1,7', 0);
model.study('std1').feature('stat').setIndex('pname', 'disp', 0);

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
model.result('pg1').feature('surf1').feature('def').set('expr', {'u' 'w'});
model.result('pg1').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg1').create('con1', 'Contour');
model.result('pg1').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg1').feature('con1').create('def', 'Deform');
model.result('pg1').feature('con1').feature('def').set('expr', {'u' 'w'});
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
model.result.dataset.create('rev1', 'Revolve2D');
model.result.dataset('rev1').set('data', 'dset1');
model.result.dataset('rev1').set('revangle', 225);
model.result.dataset('rev1').set('startangle', -90);
model.result.dataset('rev1').set('hasspacevars', true);
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').set('data', 'rev1');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg2').label('Stress, 3D (solid)');
model.result('pg2').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg2').feature('surf1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('surf1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('surf1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('surf1').feature('def').set('descractive', true);
model.result('pg2').create('con1', 'Contour');
model.result('pg2').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg2').feature('con1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('con1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('con1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('con1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('con1').feature('def').set('descractive', true);
model.result('pg2').feature('con1').set('inheritplot', 'surf1');
model.result('pg2').feature('con1').set('inheritcolor', false);
model.result('pg2').feature('con1').set('inheritrange', false);
model.result('pg2').feature('con1').set('number', 10);
model.result('pg2').feature('con1').set('colortable', 'Twilight');
model.result('pg2').feature('con1').set('descractive', true);
model.result('pg2').feature('con1').set('descr', 'Effective plastic strain');
model.result('pg2').feature('con1').label('Plastic strain');
model.result('pg2').set('legendpos', 'rightdouble');
model.result.remove('pg2');
model.result.remove('pg1');
model.result.dataset.remove('rev1');

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.1,7)', 0);

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg1').label('Stress (solid)');
model.result('pg1').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('surf1').create('def', 'Deform');
model.result('pg1').feature('surf1').feature('def').set('expr', {'u' 'w'});
model.result('pg1').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg1').create('con1', 'Contour');
model.result('pg1').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg1').feature('con1').create('def', 'Deform');
model.result('pg1').feature('con1').feature('def').set('expr', {'u' 'w'});
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
model.result.dataset.create('rev1', 'Revolve2D');
model.result.dataset('rev1').set('data', 'dset1');
model.result.dataset('rev1').set('revangle', 225);
model.result.dataset('rev1').set('startangle', -90);
model.result.dataset('rev1').set('hasspacevars', true);
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').set('data', 'rev1');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg2').label('Stress, 3D (solid)');
model.result('pg2').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg2').feature('surf1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('surf1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('surf1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('surf1').feature('def').set('descractive', true);
model.result('pg2').create('con1', 'Contour');
model.result('pg2').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg2').feature('con1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('con1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('con1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('con1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('con1').feature('def').set('descractive', true);
model.result('pg2').feature('con1').set('inheritplot', 'surf1');
model.result('pg2').feature('con1').set('inheritcolor', false);
model.result('pg2').feature('con1').set('inheritrange', false);
model.result('pg2').feature('con1').set('number', 10);
model.result('pg2').feature('con1').set('colortable', 'Twilight');
model.result('pg2').feature('con1').set('descractive', true);
model.result('pg2').feature('con1').set('descr', 'Effective plastic strain');
model.result('pg2').feature('con1').label('Plastic strain');
model.result('pg2').set('legendpos', 'rightdouble');
model.result.remove('pg2');
model.result.remove('pg1');
model.result.dataset.remove('rev1');

model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh', 'H*epe+(sigmaSF-sigma0)*(1-exp(-zeta*epe))');

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg1').label('Stress (solid)');
model.result('pg1').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('surf1').create('def', 'Deform');
model.result('pg1').feature('surf1').feature('def').set('expr', {'u' 'w'});
model.result('pg1').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg1').create('con1', 'Contour');
model.result('pg1').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg1').feature('con1').create('def', 'Deform');
model.result('pg1').feature('con1').feature('def').set('expr', {'u' 'w'});
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
model.result.dataset.create('rev1', 'Revolve2D');
model.result.dataset('rev1').set('data', 'dset1');
model.result.dataset('rev1').set('revangle', 225);
model.result.dataset('rev1').set('startangle', -90);
model.result.dataset('rev1').set('hasspacevars', true);
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').set('data', 'rev1');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg2').label('Stress, 3D (solid)');
model.result('pg2').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg2').feature('surf1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('surf1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('surf1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('surf1').feature('def').set('descractive', true);
model.result('pg2').create('con1', 'Contour');
model.result('pg2').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg2').feature('con1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('con1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('con1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('con1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('con1').feature('def').set('descractive', true);
model.result('pg2').feature('con1').set('inheritplot', 'surf1');
model.result('pg2').feature('con1').set('inheritcolor', false);
model.result('pg2').feature('con1').set('inheritrange', false);
model.result('pg2').feature('con1').set('number', 10);
model.result('pg2').feature('con1').set('colortable', 'Twilight');
model.result('pg2').feature('con1').set('descractive', true);
model.result('pg2').feature('con1').set('descr', 'Effective plastic strain');
model.result('pg2').feature('con1').label('Plastic strain');
model.result('pg2').set('legendpos', 'rightdouble');
model.result.remove('pg2');
model.result.remove('pg1');
model.result.dataset.remove('rev1');

model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh_mat', 'from_mat');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').func('an1').set('funcname', 'sig_h');
model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmagh', {'sig_h(epe)'});

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg1').label('Stress (solid)');
model.result('pg1').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('surf1').create('def', 'Deform');
model.result('pg1').feature('surf1').feature('def').set('expr', {'u' 'w'});
model.result('pg1').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg1').create('con1', 'Contour');
model.result('pg1').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg1').feature('con1').create('def', 'Deform');
model.result('pg1').feature('con1').feature('def').set('expr', {'u' 'w'});
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
model.result.dataset.create('rev1', 'Revolve2D');
model.result.dataset('rev1').set('data', 'dset1');
model.result.dataset('rev1').set('revangle', 225);
model.result.dataset('rev1').set('startangle', -90);
model.result.dataset('rev1').set('hasspacevars', true);
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').set('data', 'rev1');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg2').label('Stress, 3D (solid)');
model.result('pg2').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg2').feature('surf1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('surf1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('surf1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('surf1').feature('def').set('descractive', true);
model.result('pg2').create('con1', 'Contour');
model.result('pg2').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg2').feature('con1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('con1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('con1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('con1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('con1').feature('def').set('descractive', true);
model.result('pg2').feature('con1').set('inheritplot', 'surf1');
model.result('pg2').feature('con1').set('inheritcolor', false);
model.result('pg2').feature('con1').set('inheritrange', false);
model.result('pg2').feature('con1').set('number', 10);
model.result('pg2').feature('con1').set('colortable', 'Twilight');
model.result('pg2').feature('con1').set('descractive', true);
model.result('pg2').feature('con1').set('descr', 'Effective plastic strain');
model.result('pg2').feature('con1').label('Plastic strain');
model.result('pg2').set('legendpos', 'rightdouble');
model.result.remove('pg2');
model.result.remove('pg1');
model.result.dataset.remove('rev1');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmags', {'sigma0'});

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg1').label('Stress (solid)');
model.result('pg1').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('surf1').create('def', 'Deform');
model.result('pg1').feature('surf1').feature('def').set('expr', {'u' 'w'});
model.result('pg1').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg1').create('con1', 'Contour');
model.result('pg1').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg1').feature('con1').create('def', 'Deform');
model.result('pg1').feature('con1').feature('def').set('expr', {'u' 'w'});
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
model.result.dataset.create('rev1', 'Revolve2D');
model.result.dataset('rev1').set('data', 'dset1');
model.result.dataset('rev1').set('revangle', 225);
model.result.dataset('rev1').set('startangle', -90);
model.result.dataset('rev1').set('hasspacevars', true);
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').set('data', 'rev1');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg2').label('Stress, 3D (solid)');
model.result('pg2').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg2').feature('surf1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('surf1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('surf1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('surf1').feature('def').set('descractive', true);
model.result('pg2').create('con1', 'Contour');
model.result('pg2').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg2').feature('con1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('con1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('con1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('con1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('con1').feature('def').set('descractive', true);
model.result('pg2').feature('con1').set('inheritplot', 'surf1');
model.result('pg2').feature('con1').set('inheritcolor', false);
model.result('pg2').feature('con1').set('inheritrange', false);
model.result('pg2').feature('con1').set('number', 10);
model.result('pg2').feature('con1').set('colortable', 'Twilight');
model.result('pg2').feature('con1').set('descractive', true);
model.result('pg2').feature('con1').set('descr', 'Effective plastic strain');
model.result('pg2').feature('con1').label('Plastic strain');
model.result('pg2').set('legendpos', 'rightdouble');
model.result.remove('pg2');
model.result.remove('pg1');
model.result.dataset.remove('rev1');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmagh', {'sig_h'});

model.component('comp1').physics('solid').create('disp2', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp2').label('Prescribed Displacement Top');
model.component('comp1').physics('solid').feature('disp2').selection.set([3]);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 2);
model.component('comp1').physics('solid').feature('disp2').setIndex('U0', 'disp', 2);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-disp', 0);

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg1').label('Stress (solid)');
model.result('pg1').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('surf1').create('def', 'Deform');
model.result('pg1').feature('surf1').feature('def').set('expr', {'u' 'w'});
model.result('pg1').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg1').create('con1', 'Contour');
model.result('pg1').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg1').feature('con1').create('def', 'Deform');
model.result('pg1').feature('con1').feature('def').set('expr', {'u' 'w'});
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
model.result.dataset.create('rev1', 'Revolve2D');
model.result.dataset('rev1').set('data', 'dset1');
model.result.dataset('rev1').set('revangle', 225);
model.result.dataset('rev1').set('startangle', -90);
model.result.dataset('rev1').set('hasspacevars', true);
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').set('data', 'rev1');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg2').label('Stress, 3D (solid)');
model.result('pg2').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg2').feature('surf1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('surf1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('surf1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('surf1').feature('def').set('descractive', true);
model.result('pg2').create('con1', 'Contour');
model.result('pg2').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg2').feature('con1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('con1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('con1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('con1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('con1').feature('def').set('descractive', true);
model.result('pg2').feature('con1').set('inheritplot', 'surf1');
model.result('pg2').feature('con1').set('inheritcolor', false);
model.result('pg2').feature('con1').set('inheritrange', false);
model.result('pg2').feature('con1').set('number', 10);
model.result('pg2').feature('con1').set('colortable', 'Twilight');
model.result('pg2').feature('con1').set('descractive', true);
model.result('pg2').feature('con1').set('descr', 'Effective plastic strain');
model.result('pg2').feature('con1').label('Plastic strain');
model.result('pg2').set('legendpos', 'rightdouble');
model.result.remove('pg2');
model.result.remove('pg1');
model.result.dataset.remove('rev1');

model.study('std1').feature('stat').setIndex('punit', 'mm', 0);

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg1').label('Stress (solid)');
model.result('pg1').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('surf1').create('def', 'Deform');
model.result('pg1').feature('surf1').feature('def').set('expr', {'u' 'w'});
model.result('pg1').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg1').create('con1', 'Contour');
model.result('pg1').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg1').feature('con1').create('def', 'Deform');
model.result('pg1').feature('con1').feature('def').set('expr', {'u' 'w'});
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
model.result.dataset.create('rev1', 'Revolve2D');
model.result.dataset('rev1').set('data', 'dset1');
model.result.dataset('rev1').set('revangle', 225);
model.result.dataset('rev1').set('startangle', -90);
model.result.dataset('rev1').set('hasspacevars', true);
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').set('data', 'rev1');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg2').label('Stress, 3D (solid)');
model.result('pg2').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg2').feature('surf1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('surf1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('surf1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('surf1').feature('def').set('descractive', true);
model.result('pg2').create('con1', 'Contour');
model.result('pg2').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg2').feature('con1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('con1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('con1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('con1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('con1').feature('def').set('descractive', true);
model.result('pg2').feature('con1').set('inheritplot', 'surf1');
model.result('pg2').feature('con1').set('inheritcolor', false);
model.result('pg2').feature('con1').set('inheritrange', false);
model.result('pg2').feature('con1').set('number', 10);
model.result('pg2').feature('con1').set('colortable', 'Twilight');
model.result('pg2').feature('con1').set('descractive', true);
model.result('pg2').feature('con1').set('descr', 'Effective plastic strain');
model.result('pg2').feature('con1').label('Plastic strain');
model.result('pg2').set('legendpos', 'rightdouble');
model.result.remove('pg2');
model.result.remove('pg1');
model.result.dataset.remove('rev1');

model.component('comp1').material('mat1').propertyGroup('ElastoplasticModel').set('sigmagh', {'sig_h(epe)'});

model.param.set('epe', '0.0[mm]');
model.param.set('sig_h', '0.0[MPa]');

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg1').label('Stress (solid)');
model.result('pg1').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('surf1').create('def', 'Deform');
model.result('pg1').feature('surf1').feature('def').set('expr', {'u' 'w'});
model.result('pg1').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg1').create('con1', 'Contour');
model.result('pg1').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg1').feature('con1').create('def', 'Deform');
model.result('pg1').feature('con1').feature('def').set('expr', {'u' 'w'});
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
model.result.dataset.create('rev1', 'Revolve2D');
model.result.dataset('rev1').set('data', 'dset1');
model.result.dataset('rev1').set('revangle', 225);
model.result.dataset('rev1').set('startangle', -90);
model.result.dataset('rev1').set('hasspacevars', true);
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').set('data', 'rev1');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg2').label('Stress, 3D (solid)');
model.result('pg2').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg2').feature('surf1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('surf1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('surf1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('surf1').feature('def').set('descractive', true);
model.result('pg2').create('con1', 'Contour');
model.result('pg2').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg2').feature('con1').create('def', 'Deform');
model.result.dataset('rev1').set('hasspacevars', true);
model.result('pg2').feature('con1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('con1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('con1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('con1').feature('def').set('descractive', true);
model.result('pg2').feature('con1').set('inheritplot', 'surf1');
model.result('pg2').feature('con1').set('inheritcolor', false);
model.result('pg2').feature('con1').set('inheritrange', false);
model.result('pg2').feature('con1').set('number', 10);
model.result('pg2').feature('con1').set('colortable', 'Twilight');
model.result('pg2').feature('con1').set('descractive', true);
model.result('pg2').feature('con1').set('descr', 'Effective plastic strain');
model.result('pg2').feature('con1').label('Plastic strain');
model.result('pg2').set('legendpos', 'rightdouble');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result.export.create('anim1', 'Animation');
model.result.export('anim1').set('target', 'player');
model.result.export('anim1').set('plotgroup', 'pg2');
model.result.export('anim1').showFrame;
model.result.export.remove('anim1');
model.result('pg2').run;
model.result('pg2').create('vol1', 'Volume');
model.result('pg2').feature('vol1').set('data', 'rev1');
model.result('pg2').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature.remove('vol1');
model.result('pg2').run;

model.param.remove('epe');
model.param.set('epe', '0.0[mm]');
model.param.remove('sig_h');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('disp', '5[mm]');

model.sol('sol1').runAll;

model.result('pg1').run;

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.1,20)', 0);

model.sol('sol1').runAll;

model.result('pg1').run;

model.study('std1').feature('stat').setIndex('pname', 'epe', 0);

model.sol('sol1').runAll;

model.result('pg1').run;

model.component('comp1').physics('solid').feature('disp1').setIndex('U0', '-epe', 0);
model.component('comp1').physics('solid').feature('disp2').setIndex('U0', 'epe', 2);

model.sol('sol1').runAll;

model.result('pg1').run;

model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.1,3)', 0);

model.param.set('epe', '3[mm]');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result.dataset.create('mir1', 'Mirror3D');
model.result.dataset('mir1').set('quickplane', 'xy');
model.result.dataset.remove('rev1');
model.result('pg1').run;
model.result.dataset.create('mir1', 'Mirror3D');
model.result.dataset('mir1').set('quickplane', 'xy');
model.result('pg1').run;
model.result('pg1').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg1').run;
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg1').run;
model.result('pg1').run;
model.result('pg2').run;
model.result.create('pg3', 'PlotGroup3D');
model.result('pg3').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg1').run;
model.result('pg1').run;
model.result('pg1').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg3').run;
model.result.remove('pg3');
model.result('pg2').run;
model.result('pg2').set('data', 'none');
model.result('pg2').label('Stress 3D');
model.result.dataset.remove('mir1');
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').create('vol1', 'Volume');
model.result('pg2').run;
model.result.create('pg3', 'PlotGroup2D');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').create('surf1', 'Surface');
model.result('pg1').run;
model.result('pg1').run;
model.result('pg1').feature('surf1').set('expr', 'solid.sp1r');
model.result('pg1').feature('surf1').set('descr', 'Principal stress direction 1, r component');
model.result('pg1').feature('surf1').set('unit', 'MPa');
model.result('pg1').run;
model.result('pg1').feature('surf1').set('expr', 'solid.sp1z');
model.result('pg1').run;
model.result('pg1').feature('surf1').set('expr', 'solid.sp1phi');
model.result('pg1').run;
model.result('pg1').feature('surf1').set('expr', 'solid.sp1r');
model.result('pg1').run;
model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('surf1').set('expr', 'solid.sp1r');
model.result('pg3').run;
model.result('pg1').run;
model.result('pg3').run;
model.result.remove('pg3');
model.result('pg2').run;
model.result.dataset.create('rev1', 'Revolve2D');
model.result('pg1').run;
model.result('pg2').run;
model.result.remove('pg2');
model.result('pg1').run;
model.result.remove('pg1');
model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').set('data', 'dset1');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg1').label('Stress (solid)');
model.result('pg1').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('surf1').create('def', 'Deform');
model.result('pg1').feature('surf1').feature('def').set('expr', {'u' 'w'});
model.result('pg1').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg1').create('con1', 'Contour');
model.result('pg1').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg1').feature('con1').create('def', 'Deform');
model.result('pg1').feature('con1').feature('def').set('expr', {'u' 'w'});
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
model.result.dataset.create('rev2', 'Revolve2D');
model.result.dataset('rev2').set('data', 'dset1');
model.result.dataset('rev2').set('revangle', 225);
model.result.dataset('rev2').set('startangle', -90);
model.result.dataset('rev2').set('hasspacevars', true);
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').set('data', 'rev2');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', {'solid.misesGp'});
model.result('pg2').label('Stress, 3D (solid)');
model.result('pg2').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg2').feature('surf1').create('def', 'Deform');
model.result.dataset('rev2').set('hasspacevars', true);
model.result('pg2').feature('surf1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('surf1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('surf1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('surf1').feature('def').set('descractive', true);
model.result('pg2').create('con1', 'Contour');
model.result('pg2').feature('con1').set('expr', {'if(isnan(solid.epeGp),NaN,solid.epeGp)'});
model.result('pg2').feature('con1').create('def', 'Deform');
model.result.dataset('rev2').set('hasspacevars', true);
model.result('pg2').feature('con1').feature('def').set('revcoordsys', 'cylindrical');
model.result('pg2').feature('con1').feature('def').set('expr', {'u' '0' 'w'});
model.result('pg2').feature('con1').feature('def').set('descr', 'Displacement field');
model.result('pg2').feature('con1').feature('def').set('descractive', true);
model.result('pg2').feature('con1').set('inheritplot', 'surf1');
model.result('pg2').feature('con1').set('inheritcolor', false);
model.result('pg2').feature('con1').set('inheritrange', false);
model.result('pg2').feature('con1').set('number', 10);
model.result('pg2').feature('con1').set('colortable', 'Twilight');
model.result('pg2').feature('con1').set('descractive', true);
model.result('pg2').feature('con1').set('descr', 'Effective plastic strain');
model.result('pg2').feature('con1').label('Plastic strain');
model.result('pg2').set('legendpos', 'rightdouble');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').create('surf2', 'Surface');
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature.remove('surf2');
model.result('pg2').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').create('surf2', 'Surface');
model.result('pg2').feature('surf2').set('expr', 'solid.misesGp');
model.result.dataset.create('mir1', 'Mirror3D');
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result.dataset('mir1').set('data', 'rev2');
model.result.dataset('mir1').set('quickplane', 'xy');
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature('surf2').set('data', 'mir1');
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature.remove('surf1');
model.result('pg2').run;
model.result('pg2').run;

model.label('teste0.mph');

model.result('pg2').run;

model.component('comp1').geom('geom1').lengthUnit('mm');
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').material.create('mat2', 'Common');
model.component('comp1').material('mat2').label('A2 [solid]');
model.component('comp1').material('mat2').info.create('DIN');
model.component('comp1').material('mat2').info('DIN').body('X100CrMoV5-1');
model.component('comp1').material('mat2').info.create('UNS');
model.component('comp1').material('mat2').info('UNS').body('T30102');
model.component('comp1').material('mat2').info.create('Composition');
model.component('comp1').material('mat2').info('Composition').body('bal. Fe, (0.95-1.05) C, (4.75-5.5) Cr, 1 Mn max, 0.3 Ni max, 0.5 Si max, (0.9-1.4) W, (0.15-0.5) V (wt%)');
model.component('comp1').material('mat2').propertyGroup('def').set('thermalconductivity', 'k(T[1/K])[W/(m*K)]');
model.component('comp1').material('mat2').propertyGroup('def').set('thermalexpansioncoefficient', '(alpha(T[1/K])[1/K]+(Tempref-293[K])*if(abs(T-Tempref)>1e-3,(alpha(T[1/K])[1/K]-alpha(Tempref[1/K])[1/K])/(T-Tempref),d(alpha(T[1/K])[1/K],T)))/(1+alpha(Tempref[1/K])[1/K]*(Tempref-293[K]))');
model.component('comp1').material('mat2').propertyGroup('def').set('density', 'rho(T[1/K])[kg/m^3]');
model.component('comp1').material('mat2').propertyGroup('def').func.create('k', 'Piecewise');
model.component('comp1').material('mat2').propertyGroup('def').func('k').set('funcname', 'k');
model.component('comp1').material('mat2').propertyGroup('def').func('k').set('arg', 'T');
model.component('comp1').material('mat2').propertyGroup('def').func('k').set('extrap', 'constant');
model.component('comp1').material('mat2').propertyGroup('def').func('k').set('pieces', {'293.0' '673.0' '25.08138+0.001635965*T^1+5.116959E-6*T^2'});
model.component('comp1').material('mat2').propertyGroup('def').func('k').label('Piecewise');
model.component('comp1').material('mat2').propertyGroup('def').func('k').set('fununit', '');
model.component('comp1').material('mat2').propertyGroup('def').func('k').set('argunit', '');
model.component('comp1').material('mat2').propertyGroup('def').func.create('alpha', 'Piecewise');
model.component('comp1').material('mat2').propertyGroup('def').func('alpha').set('funcname', 'alpha');
model.component('comp1').material('mat2').propertyGroup('def').func('alpha').set('arg', 'T');
model.component('comp1').material('mat2').propertyGroup('def').func('alpha').set('extrap', 'constant');
model.component('comp1').material('mat2').propertyGroup('def').func('alpha').set('pieces', {'293.0' '1023.0' '2.050434E-6+3.496482E-8*T^1-3.638835E-11*T^2+1.372743E-14*T^3'});
model.component('comp1').material('mat2').propertyGroup('def').func('alpha').label('Piecewise 1');
model.component('comp1').material('mat2').propertyGroup('def').func('alpha').set('fununit', '');
model.component('comp1').material('mat2').propertyGroup('def').func('alpha').set('argunit', '');
model.component('comp1').material('mat2').propertyGroup('def').func.create('rho', 'Piecewise');
model.component('comp1').material('mat2').propertyGroup('def').func('rho').set('funcname', 'rho');
model.component('comp1').material('mat2').propertyGroup('def').func('rho').set('arg', 'T');
model.component('comp1').material('mat2').propertyGroup('def').func('rho').set('extrap', 'constant');
model.component('comp1').material('mat2').propertyGroup('def').func('rho').set('pieces', {'293.0' '1023.0' '7940.567-0.2483825*T^1-6.723615E-5*T^2'});
model.component('comp1').material('mat2').propertyGroup('def').func('rho').label('Piecewise 2');
model.component('comp1').material('mat2').propertyGroup('def').func('rho').set('fununit', '');
model.component('comp1').material('mat2').propertyGroup('def').func('rho').set('argunit', '');
model.component('comp1').material('mat2').propertyGroup('def').addInput('temperature');
model.component('comp1').material('mat2').propertyGroup('def').addInput('strainreferencetemperature');
model.component('comp1').material('mat2').propertyGroup.create('ThermalExpansion', 'Thermal expansion');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').set('dL', '(dL(T[1/K])-dL(Tempref[1/K]))/(1+dL(Tempref[1/K]))');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').set('dLIso', '(dL(T[1/K])-dL(Tempref[1/K]))/(1+dL(Tempref[1/K]))');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').set('alphatan', 'CTE(T[1/K])[1/K]');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').set('alphatanIso', 'CTE(T[1/K])[1/K]');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func.create('dL', 'Piecewise');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('dL').set('funcname', 'dL');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('dL').set('arg', 'T');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('dL').set('extrap', 'constant');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('dL').set('pieces', {'293.0' '1023.0' '-0.00327594124+1.020694E-5*T^1+3.323368E-9*T^2'});
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('dL').label('Piecewise');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('dL').set('fununit', '');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('dL').set('argunit', '');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func.create('CTE', 'Piecewise');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('CTE').set('funcname', 'CTE');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('CTE').set('arg', 'T');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('CTE').set('extrap', 'constant');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('CTE').set('pieces', {'293.0' '1023.0' '1.020694E-5+6.646736E-9*T^1'});
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('CTE').label('Piecewise 1');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('CTE').set('fununit', '');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').func('CTE').set('argunit', '');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').addInput('temperature');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').addInput('strainreferencetemperature');
model.component('comp1').material('mat2').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat2').propertyGroup('Enu').set('youngsmodulus', 'E(T[1/K])[Pa]');
model.component('comp1').material('mat2').propertyGroup('Enu').func.create('E', 'Piecewise');
model.component('comp1').material('mat2').propertyGroup('Enu').func('E').set('funcname', 'E');
model.component('comp1').material('mat2').propertyGroup('Enu').func('E').set('arg', 'T');
model.component('comp1').material('mat2').propertyGroup('Enu').func('E').set('extrap', 'constant');
model.component('comp1').material('mat2').propertyGroup('Enu').func('E').set('pieces', {'293.0' '673.0' '1.809166E11+6.741228E7*T^1-124269.0*T^2'});
model.component('comp1').material('mat2').propertyGroup('Enu').func('E').label('Piecewise');
model.component('comp1').material('mat2').propertyGroup('Enu').func('E').set('fununit', '');
model.component('comp1').material('mat2').propertyGroup('Enu').func('E').set('argunit', '');
model.component('comp1').material('mat2').propertyGroup('Enu').addInput('temperature');
model.component('comp1').material('mat2').set('family', 'steel');
model.component('comp1').material('mat2').propertyGroup('ThermalExpansion').active(false);
model.component('comp1').material('mat2').propertyGroup.create('ElastoplasticModel', 'Elastoplastic material model');
model.component('comp1').material.remove('mat1');
model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').func.create('an1', 'Analytic');
model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').func('an1').label('sig_h');
model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+(sigma0-sigmaSF)*(1-exp(-zeta*epe))');
model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').func('an1').set('args', 'epe');
model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').func('an1').set('argunit', 'u');
model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').set('sigmagh', {'sig_h(epe)'});

model.param.remove('ho');
model.param.remove('ro');
model.param.remove('sigmaSF');
model.param.remove('H');
model.param.remove('zeta');
model.param.remove('sigma0');
model.param.remove('disp');
model.param.remove('epe');
model.param.set('sigma0', '450[MPa]', 'Inital Yield Stress');
model.param.set('sigmaSF', '715[MPa]', 'Saturation flow stress');
model.param.set('H', '129.24[MPa]', 'Linear Hardening coeficient');
model.param.set('zeta', '16.93', 'Saturation expoent');
model.param.set('delta', '0[mm]', 'Top displacement');
model.param.set('H0', '53.334[mm]', 'Bar Length');
model.param.set('R0', '6.413[mm]', 'Bar radius');
model.param.set('E_a', '206.9[GPa]', 'Young''s Modulus');
model.param.set('epe', '0[mm]');

model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').func('an1').set('expr', 'H*epe+(sigmaSF-sigma0)*(1-exp(-zeta*epe))');
model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').func('an1').set('argunit', '1');
model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').func('an1').set('fununit', 'Pa');
model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').addInput('effectiveplasticstrain');

model.component('comp1').geom('geom1').feature('r1').set('size', {'R0' 'H0/2'});
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').physics('solid').feature.move('disp2', 5);
model.component('comp1').physics('solid').feature('disp2').setIndex('U0', 'delta', 2);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 2);
model.component('comp1').physics('solid').create('fix1', 'Fixed', 1);
model.component('comp1').physics('solid').feature.remove('fix1');

model.study('std1').feature('stat').setIndex('pname', 'sigma0', 0);
model.study('std1').feature('stat').setIndex('plistarr', '', 0);
model.study('std1').feature('stat').setIndex('punit', 'Pa', 0);
model.study('std1').feature('stat').setIndex('pname', 'sigma0', 0);
model.study('std1').feature('stat').setIndex('plistarr', '', 0);
model.study('std1').feature('stat').setIndex('punit', 'Pa', 0);
model.study('std1').feature('stat').setIndex('pname', 'delta', 0);
model.study('std1').feature('stat').setIndex('plistarr', 'range(0,0.1,7)', 0);
model.study('std1').feature('stat').setIndex('punit', 'mm', 0);

model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').feature('size').set('hauto', 3);
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').feature.remove('ftri1');
model.component('comp1').mesh('mesh1').create('map1', 'Map');
model.component('comp1').mesh('mesh1').feature('map1').selection.geom('geom1');
model.component('comp1').mesh('mesh1').run('map1');
model.component('comp1').mesh('mesh1').feature('map1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('map1').selection.all;
model.component('comp1').mesh('mesh1').feature('map1').set('smoothmaxdepth', 3);
model.component('comp1').mesh('mesh1').run('map1');
model.component('comp1').mesh('mesh1').feature('map1').set('smoothmaxdepth', 8);
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').automatic(true);
model.component('comp1').mesh('mesh1').autoMeshSize(3);
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').automatic(false);
model.component('comp1').mesh('mesh1').run('ftri1');
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').create('map1', 'Map');
model.component('comp1').mesh('mesh1').feature.remove('ftri1');
model.component('comp1').mesh('mesh1').feature('map1').selection.geom('geom1');
model.component('comp1').mesh('mesh1').feature('map1').set('smoothcontrol', true);
model.component('comp1').mesh('mesh1').feature('size').set('custom', false);
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').feature('size').set('hauto', 4);
model.component('comp1').mesh('mesh1').run('size');
model.component('comp1').mesh('mesh1').run;

model.component('comp1').material('mat2').propertyGroup('Enu').set('youngsmodulus', {'E_a'});

model.component('comp1').physics('solid').feature('lemm1').set('E_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').set('E', 'E_a');
model.component('comp1').physics('solid').feature('lemm1').set('nu_mat', 'from_mat');
model.component('comp1').physics('solid').feature('lemm1').set('rho_mat', 'from_mat');

model.param.set('num', '0.29');
model.param.descr('num', 'Poisson''s Ratio');

model.component('comp1').material('mat2').propertyGroup('Enu').set('poissonsratio', {'poi'});

model.param.rename('num', 'nu');

model.component('comp1').material('mat2').propertyGroup('Enu').set('poissonsratio', {'poi'});

model.param.rename('nu', 'poi');

model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').set('sigmags', {'sigma0'});

model.component('comp1').physics('solid').feature('lemm1').set('nu_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').set('nu', 'poi');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmags_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmags', 'sigma0');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh', 'sig_h(epe)');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('KinematicHardeningModel', 'ArmstrongFrederick');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh', 'sig_h');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('KinematicHardeningModel', 'NoKinematicHardening');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmags_mat', 'from_mat');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh_mat', 'from_mat');
model.component('comp1').physics('solid').feature('lemm1').set('E_mat', 'from_mat');
model.component('comp1').physics('solid').feature('lemm1').set('nu_mat', 'from_mat');

model.component('comp1').material('mat2').selection.geom('geom1', 1);
model.component('comp1').material('mat2').selection.geom('geom1', 2);
model.component('comp1').material('mat2').selection.set([1]);

model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh', 'sig_h(epe)');

model.component('comp1').material('mat2').propertyGroup('ElastoplasticModel').func('an1').set('funcname', 'sig_h');

model.component('comp1').physics('solid').feature('lemm1').feature('plsty1').set('sigmagh_mat', 'from_mat');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 2);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('U0', 0, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 2);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', true, 0);
model.component('comp1').physics('solid').feature('disp2').setIndex('Direction', false, 0);

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.sol('sol1').runAll;

model.result('pg1').run;

model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 0);
model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', false, 2);

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').mesh('mesh1').feature('size').set('hauto', 3);
model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result.dataset.remove('rev1');
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result.create('pg3', 'PlotGroup1D');
model.result('pg3').run;
model.result('pg3').create('lngr1', 'LineGraph');
model.result('pg3').feature('lngr1').set('data', 'dset1');
model.result('pg3').feature('lngr1').setIndex('looplevelinput', 'manualindices', 0);
model.result('pg3').feature('lngr1').setIndex('looplevelinput', 'first', 0);
model.result('pg3').feature('lngr1').setIndex('looplevelinput', 'all', 0);
model.result('pg3').feature('lngr1').selection.all;
model.result('pg3').feature('lngr1').selection.set([3]);
model.result('pg3').run;
model.result('pg3').feature('lngr1').set('expr', 'solid.sp1z');
model.result('pg3').feature('lngr1').set('descr', 'Principal stress direction 1, z component');
model.result('pg3').feature('lngr1').set('unit', 'MPa');
model.result('pg3').feature('lngr1').set('xdata', 'expr');
model.result('pg3').run;

model.sol('sol1').runAll;

model.result('pg1').run;

model.label('teste0.mph');

model.result('pg1').run;
model.result('pg2').run;
model.result('pg1').run;

model.component('comp1').physics('solid').feature('disp2').setIndex('U0', '-delta', 2);

model.sol('sol1').runAll;

model.result('pg1').run;

model.component('comp1').physics('solid').feature('disp1').setIndex('Direction', true, 2);

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('lngr1').selection.set([3]);
model.result('pg3').run;
model.result('pg3').feature('lngr1').set('expr', 'solid.sp1');
model.result('pg3').run;
model.result('pg3').feature('lngr1').set('expr', 'solid.sp2');
model.result('pg3').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg2').run;

model.component('comp1').physics('solid').feature('disp2').setIndex('U0', '-epe', 2);

model.study('std1').feature('stat').setIndex('pname', 'epe', 0);

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').feature('lngr1').set('expr', 'solid.sp2z');
model.result('pg3').run;
model.result('pg3').feature('lngr1').set('expr', 'solid.sp2r');
model.result('pg3').run;
model.result('pg3').feature('lngr1').set('expr', 'solid.sp1z');
model.result('pg3').run;

out = model;
