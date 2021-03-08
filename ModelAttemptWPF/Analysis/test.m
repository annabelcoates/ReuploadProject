this_script_path = fileparts(mfilename('fullpath'));
disp (this_script_path);
disp (pwd);
cd (this_script_path);
disp (pwd);