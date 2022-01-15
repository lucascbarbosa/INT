function Es = main(dimension,start_geometry,end_geometry,save_model)

    arrays_dir = 'E:\Lucas GAN\Dados\1- Arranged_geometries\Arrays\RTGA\p4\';
    models_dir = strcat('E:\Lucas GAN\Dados\2- Models\MATLAB\',int2str(dimension),'D\');
    young_dir = 'E:\Lucas GAN\Dados\3- Mechanical_properties\young_COMSOL\';

    datadirs = dir(arrays_dir); 
    dircell = struct2cell(datadirs)';   
    filenames = dircell(:,1);

    Es = [];
    
    dtheta = 45;
    theta_max = 45;
    
    for fid = (start_geometry:end_geometry)
        filename = string(filenames{fid+2});
        datafilename = strcat(arrays_dir,filename);
        f  = fopen(datafilename,'r');
        file_out = fopen(strcat(young_dir,filename),'wt');
        model_name = split(filename,".txt");
        model_name = string(model_name{1});
        model_name = split(model_name,"_");
        idx_dir = models_dir+model_name(1)+"\";
        if ~exist(idx_dir, 'dir')
            mkdir(idx_dir);
        end
        array = get_array(f);
        fclose(f);
    
        for theta = 0:dtheta:theta_max
            model_filename = idx_dir+model_name(2)+"_"+model_name(3)+"_theta_"+int2str(theta)+".mph";
            disp(theta);
            E = 0;
            try
                if dimension==2
                    [model,E] = simulation_2d(array,theta,model_filename,save_model);
                else
                    [model,E] = simulation_3d(array,theta,model_filename,save_model);
                end
            catch
                try
                    disp(theta+1);
                    if dimension==2
                        [model,E] = simulation_2d(array,theta,model_filename,save_model);
                    else
                        [model,E] = simulation_3d(array,theta,model_filename,save_model);
                    end
                catch
                    try
                        disp(theta-1);
                    	if dimension==2
                            [model,E] = simulation_2d(array,theta,model_filename,save_model);
                        else
                            [model,E] = simulation_3d(array,theta,model_filename,save_model);
                        end
                    catch
                        approved(fid) = false;
                    end
                end
            end
            Es(fid,int8(theta/dtheta)+1) = E;
        end
        fprintf(file_out,'%d\n',Es(fid,:)');
        fclose(file_out);
    end
end