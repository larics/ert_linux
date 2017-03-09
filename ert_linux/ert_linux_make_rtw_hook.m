function ert_linux_make_rtw_hook(hookMethod,modelName,~,~,~,~)
switch hookMethod
    case 'after_make'
        linuxAfterMakeHook(modelName);
end
