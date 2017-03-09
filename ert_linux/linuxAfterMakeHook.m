function [ ] = linuxAfterMakeHook( modelName )


%  Sending TERM signal to previously started process. Model is terminated
%  by PID listed in /Simulink/started file. TERM signal is sent without 
%  checking if the listed process has previously been terminated.

disp('Killing started models...');
system('ssh root@161.53.68.185 ''kill $(cat /Simulink/started)''');



%  Every previously loaded model is deleted (every file in /Simulink/models/ is removed).

disp('Removing previously loaded models...');
unix('ssh root@161.53.68.185 ''rm /Simulink/models/$(ls /Simulink/models/)''');



%  New model is downloaded via 'scp' to /Simulink/models/
%  Access mode is changed to allow model execution

disp('Downloading model to target...');
unix(['scp -q ' pwd '/../' modelName ' root@161.53.68.185:/Simulink/models']);
unix(['ssh root@161.53.68.185 ''chmod +x /Simulink/models/' modelName '''']);




%  Model is executed with '-w' option waiting to be started via Simulink command interface
%  Model is executed as backgorund process and all I/O streams are redirected to allow exiting 
%  ssh session (shell hanging on logout otherwise)

%  Process PID is redirected to /Simulink/started file

disp('Model waiting for start...');
unix(['ssh root@161.53.68.185 ''nohup /Simulink/models/' modelName ' -w > foo.out 2>foo.err </dev/null & echo $! > /Simulink/started''']);


end 
