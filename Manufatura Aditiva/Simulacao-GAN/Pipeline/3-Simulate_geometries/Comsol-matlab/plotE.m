function plotE(Es,dtheta,theta_max,interp)
    theta = 0:dtheta:theta_max;
    theta = deg2rad(theta);
    
    if interp == true
        thetaq = 0:0.1:theta_max;
        thetaq = deg2rad(thetaq);
        E_int = interp1(theta,Es,thetaq,'spline');
        polarplot(thetaq,E_int);

    else
        polarplot(theta,Es);
    end
    
    
end