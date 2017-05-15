function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 30-Apr-2017 11:33:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)




% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

set(handles.SolenoidValve ,'Visible','off')
set(handles.NeedleValve ,'Visible','off')
set(get(handles.SolenoidValve,'children'),'visible','off')
set(get(handles.NeedleValve,'children'),'visible','off')

title(handles.DeviceV, 'Velocity Of Device along the Beam pipe')
title(handles.AirV, 'Air Inlet Velocity to Beam Pipe Over Time')
title(handles.NeedleValve, 'Signal to inlet valve (mA)')
title(handles.SolenoidValve, 'Signal to Solenoid Valve (1 = On, 0 = Off)')

sliderValue = num2str( get(handles.slider2,'Value') );
set(handles.ProportionalController,'String', sliderValue);

sliderValue = num2str( get(handles.slider3,'Value') );
set(handles.DerivativeController,'String', sliderValue);




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

xclean = str2double(get(hObject,'String'));
if isnan(xclean) || ~isreal(xclean)
    % Disable the Plot button and change its string to say why
    set(handles.Run,'String','Cannot plot x');
    set(handles.Run,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else 
    % Enable the Plot button with its original name
    set(handles.Run,'String','Plot');
    set(handles.Run,'Enable','on');
end

set(handles.slider1,'Value',xclean);



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refreshdata(handles.DeviceV)
refreshdata(handles.SolenoidValve)


%xclean = str2double(get(handles.slider1,'Value'));
xclean = get(handles.slider1,'Value');
StartRef = str2double(get(handles.editStarting,'String'));
LeaveRef = str2double(get(handles.editLeave,'String'));

txt = get(handles.popupmenu2,'Value');

switch txt
    
    case 1 
        num = 1;
    case 2
        num = 2;
    case 3
        num = 3;
    case 4
        num = 4;
    otherwise
end

kp = get(handles.slider2, 'Value');
kd = get(handles.slider3, 'Value');


[x,v,Vair,time, Refv, CleanDist, spray, NeedleValve, timestart, timestop] = Model(xclean, StartRef, LeaveRef, num, kp,kd);
set(handles.EditClean,'String', CleanDist);
set(handles.editTime,'String', max(time)/60);


plot(handles.DeviceV, x,Refv,'--b', x, v, 'r');

legend(handles.DeviceV, 'Reference Velocity (m/s)', 'Device Velocity (m/s)')
xlabel(handles.DeviceV, 'Distance along beam pipe (m)')
ylabel(handles.DeviceV, 'Reference Velocity of device (m/s)')
axis(handles.DeviceV,[0 2800 0 (max(v)+1)])
title(handles.DeviceV, 'Velocity Of Device along the Beam pipe')

plot(handles.AirV,time, Vair)
xlabel(handles.AirV,'Time (s)')
ylabel(handles.AirV,'Velocity of Air (m/s)')
title(handles.AirV, 'Air Inlet Velocity to Beam Pipe Over Time')

if get(handles.checkbox1, 'Value')
    plot(handles.SolenoidValve, time, spray, 'k')
    title(handles.SolenoidValve, 'Signal to Solenoid Valve (1 = On, 0 = Off)')
    axis(handles.SolenoidValve, [timestart timestop -0.5 1.5])
    xlabel(handles.SolenoidValve, 'Time(s)')
    ylabel(handles.SolenoidValve, 'Signal')
end

if get(handles.checkbox1, 'Value')
    plot(handles.NeedleValve, time, NeedleValve, 'm')
    title(handles.NeedleValve, 'Signal to inlet valve')
    xlabel(handles.NeedleValve, 'Time(s)')
    ylabel(handles.NeedleValve, 'Current (mA)')
end

if max(v) > 10 
    message = sprintf('System is Unstable \n\nThe maximum velocity is %d (m/s) which may cause significant damage \n\nIt is recommended that you reduce the proportional controller \nor the reference exit velocity', round(max(v)));
    uiwait(msgbox(message));
end

if v(length(v)) > 5
     message = sprintf('System is Unstable \n\nThe exit velocity is %d (m/s) which may cause significant damage to the device on exit \n\nIt is recommended that you reduce the proportional controller \nor the reference exit velocity', round(v(length(v))));
    uiwait(msgbox(message));
end

function editStarting_Callback(hObject, eventdata, handles)
% hObject    handle to editStarting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStarting as text
%        str2double(get(hObject,'String')) returns contents of editStarting as a double
Vstart = str2double(get(handles.editStarting, 'string'));

if isnan(Vstart) || ~isreal(Vstart)
    % Disable the Plot button and change its string to say why
    set(handles.Run,'String','Enter a Number for the Reference Velocity');
    set(handles.Run,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else 
    % Enable the Plot button with its original name
    set(handles.Run,'String','Plot');
    set(handles.Run,'Enable','on');
end

if Vstart > 5 || Vstart < 0
    set(handles.Run,'String','Enter a Ref Velocity  between 0 and 5');
    set(handles.Run,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else
    % Enable the Plot button with its original name
    set(handles.Run,'String','Plot');
    set(handles.Run,'Enable','on');
end


% --- Executes during object creation, after setting all properties.
function editStarting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStarting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editLeave_Callback(hObject, eventdata, handles)
% hObject    handle to editLeave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLeave as text
%        str2double(get(hObject,'String')) returns contents of editLeave as a double
Vend = str2double(get(handles.editLeave, 'string'));

if isnan(Vend) || ~isreal(Vend)
    % Disable the Plot button and change its string to say why
    set(handles.Run,'String','Enter a Number for the Reference Velocity');
    set(handles.Run,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else 
    % Enable the Plot button with its original name
    set(handles.Run,'String','Plot');
    set(handles.Run,'Enable','on');
end

if Vend > 5 || Vend < 0
    set(handles.Run,'String','Enter a Ref Velocity  between 0 and 5');
    set(handles.Run,'Enable','off');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject);
else 
    % Enable the Plot button with its original name
    set(handles.Run,'String','Plot');
    set(handles.Run,'Enable','on');
end


% --- Executes during object creation, after setting all properties.
function editLeave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLeave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderValue = num2str( get(hObject,'Value') );
set(handles.edit1,'String', sliderValue);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editTime_Callback(hObject, eventdata, handles)
% hObject    handle to editTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTime as text
%        str2double(get(hObject,'String')) returns contents of editTime as a double



% --- Executes during object creation, after setting all properties.
function editTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditClean_Callback(hObject, eventdata, handles)
% hObject    handle to EditClean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditClean as text
%        str2double(get(hObject,'String')) returns contents of EditClean as a double


% --- Executes during object creation, after setting all properties.
function EditClean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditClean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
check = get(hObject,'Value');
if check == 1;
    set(handles.SolenoidValve ,'Visible','on')
    set(handles.NeedleValve ,'Visible','on')
    set(get(handles.NeedleValve,'children'),'visible','on')
    set(get(handles.SolenoidValve,'children'),'visible','on')
end
if check == 0;
    set(handles.SolenoidValve ,'Visible','off')
    set(handles.NeedleValve ,'Visible','off')
    set(get(handles.NeedleValve,'children'),'visible','off')
    set(get(handles.SolenoidValve,'children'),'visible','off')
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderValue = num2str( get(hObject,'Value') );
set(handles.ProportionalController,'String', sliderValue);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderValue = num2str( get(hObject,'Value') );
set(handles.DerivativeController,'String', sliderValue);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ProportionalController_Callback(hObject, eventdata, handles)
% hObject    handle to ProportionalController (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ProportionalController as text
%        str2double(get(hObject,'String')) returns contents of ProportionalController as a double


% --- Executes during object creation, after setting all properties.
function ProportionalController_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProportionalController (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DerivativeController_Callback(hObject, eventdata, handles)
% hObject    handle to DerivativeController (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DerivativeController as text
%        str2double(get(hObject,'String')) returns contents of DerivativeController as a double


% --- Executes during object creation, after setting all properties.
function DerivativeController_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DerivativeController (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
