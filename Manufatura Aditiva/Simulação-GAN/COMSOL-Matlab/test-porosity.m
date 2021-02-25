function out = model
%
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
ys0 = 400.0;
epe = 0.0;
dispmax = 20.0;
young = 15.0;
poisson = 0.29;
width = 0.1;
height = 0.1;
C_k = 129.24;
gamma_k = 100.0;
resolution = 10;
void_size = width/resolution;

model.param.set('disp', [num2str(disp,'%.2f') '' '[mm]'], 'prescribed displacement');
model.param.set('zeta', num2str(zeta,'%.2f'), 'hardening law parameter');
model.param.set('H', [num2str(H,'%.2f') '' '[MPa]'], 'hardening law parameter');
model.param.set('sigmars', [num2str(sigmars,'%.2f') '' '[MPa]'], 'hardening law parameter');
model.param.set('ys0', [num2str(ys0,'%.2f') '' '[MPa]'], 'Initial yield stress');
model.param.set('epe', [num2str(epe,'%.2f') '' '[mm]'], 'strain');
model.param.set('dispmax', [num2str(dispmax,'%.2f') '' '[mm]'], 'maximum displacement');
model.param.set('young', [num2str(young,'%.2f') '' '[GPa]'], 'young''s modulus');
model.param.set('poisson', num2str(poisson,'%.2f'), 'poisson''s modulus');
model.param.set('width', [num2str(width,'%.2f') '' '[m]'], 'specimen width');
model.param.set('height',  [num2str(height,'%.2f') '' '[m]'], 'speciment hieght');
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
model.component('comp1').geom('geom1').feature('r1').set('pos', [3*width/4 0]);
model.component('comp1').geom('geom1').run('r1');
model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').set('size', [void_size void_size]);
model.component('comp1').geom('geom1').feature('r2').set('base', 'center');
model.component('comp1').geom('geom1').feature('r2').set('pos', [3*height/4 0]);
model.component('comp1').geom('geom1').run('r2');
model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'sq'});
model.component('comp1').geom('geom1').feature('dif1').selection('input2').set({'r1' 'r2'});
model.component('comp1').geom('geom1').run('dif1');
model.component('comp1').geom('geom1').run;


