function [Es,approved] = main(dimension,simmetry,start_geometry,end_geometry,save_model)

    arrays_dir = 'E:\Lucas GAN\Dados\1- Arranged_geometries\RTGA\p4\';
    models_dir = strcat('E:\Lucas GAN\Dados\2- Geometry_models\MATLAB\',int2str(dimension),'D\');
    young_dir = strcat('E:\Lucas GAN\Dados\3- Mechanical_properties\young\MATLAB\',int2str(dimension),'D\',simmetry,'\');

    datadirs = dir(arrays_dir); 
    dircell = struct2cell(datadirs)';   
    filenames = dircell(:,1);

    Es = [];
    
    dtheta = 45;
    theta_max = 45;
    
    for fid = (start_geometry+2:end_geometry+2)
        filename = filenames{fid}
        file_out = fopen(strcat(young_dir,filename),'wt');
        model_name = split(filename,".txt");
        model_name = string(model_name{1});
        model_name = split(model_name,"_");
        idx_dir = models_dir+model_name(1)+"\";
        if ~exist(idx_dir, 'dir')
            mkdir(idx_dir);
        end
        
        array = get_array(fid);
    
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
                approved(fid-2) = true;
            catch
                try
                    disp(theta+1);
                    if dimension==2
                        [model,E] = simulation_2d(array,theta,model_filename,save_model);
                    else
                        [model,E] = simulation_3d(array,theta,model_filename,save_model);
                    end
                    approved(fid-2) = true;
                catch
                    try
                        disp(theta-1);
                    	if dimension==2
                            [model,E] = simulation_2d(array,theta,model_filename,save_model);
                        else
                            [model,E] = simulation_3d(array,theta,model_filename,save_model);
                        end
                        approved(fid-2) = true;
                    catch
                        approved(fid-2) = false;
                        E = 0;
                    end
                end
            end
            Es(fid-2,int8(theta/dtheta)+1) = E;
        end
        fprintf(file_out,'%d\n',Es(fid-2,:)');
        fclose(file_out);
    end
end