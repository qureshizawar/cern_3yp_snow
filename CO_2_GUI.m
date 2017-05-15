function varargout = CO_2_GUI(varargin)
% CO_2_GUI MATLAB code for CO_2_GUI.fig
%      CO_2_GUI, by itself, creates a new CO_2_GUI or raises the existing
%      singleton*.
%
%      H = CO_2_GUI returns the handle to a new CO_2_GUI or the handle to
%      the existing singleton*.
%
%      CO_2_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CO_2_GUI.M with the given input arguments.
%
%      CO_2_GUI('Property','Value',...) creates a new CO_2_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CO_2_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CO_2_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CO_2_GUI

% Last Modified by GUIDE v2.5 04-May-2017 15:10:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CO_2_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CO_2_GUI_OutputFcn, ...
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


% --- Executes just before CO_2_GUI is made visible.
function CO_2_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CO_2_GUI (see VARARGIN)

set(handles.text3,'String',get(handles.slider1,'Value'));
set(handles.text4,'String',get(handles.slider2,'Value'));
set(handles.text5,'String',get(handles.slider3,'Value'));

% Choose default command line output for CO_2_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CO_2_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CO_2_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


sliderval = num2str(get(hObject,'Value'));
assignin('base','sliderval',sliderval);
% set(handles.D,'String', sliderval);
set(handles.text3,'String',num2str(sliderval));
% set(handles.text3,'string',sliderval);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

txt = get(handles.popupmenu3,'Value');

switch txt
    
    case 1
        num = 40.0e-20;
    case 2
        num = 36.0e-20;
    case 3
        num = 16.75e-20;
    otherwise
end


Velocity = get(handles.slider2,'Value');
SnowSize = get(handles.slider3,'Value')*0.5*1e-6;
Seperation = get(handles.slider1,'Value')*1e-9;
Material = num;

i = 100;
Ls = linspace( 1*10^-6,100*10^-6,i);

[drag, momentum, vanderwaals, total] = get_aero_vs_momentum(Velocity, SnowSize, Seperation, Material,Ls);

plot(handles.axes1,Ls,drag,'b--',Ls,momentum,'g--',Ls,total,'m',Ls,vanderwaals,'r','LineWidth',2')

grid (handles.axes1,'on')
title(handles.axes1,'Adhesive vs Removal Force')
xlabel(handles.axes1,'Particle diameter(m)')
ylabel(handles.axes1,'Force (N)')
legend(handles.axes1,'Aero drag','Momentum','Total removal force','Van der Waals')

Qs = linspace( 1*10^-6,10*10^-6,i);
[drag, momentum, vanderwaals, total] = get_aero_vs_momentum(Velocity, SnowSize, Seperation, Material,Qs);

plot(handles.axes2,Qs,drag,'b--',Qs,momentum,'g--',Qs,total,'m',Qs,vanderwaals,'r','LineWidth',2')

grid (handles.axes2,'on')
title(handles.axes2,'Adhesive vs Removal Force(1-10um)')
xlabel(handles.axes2,'Particle diameter(m)')
ylabel(handles.axes2,'Force (N)')
legend(handles.axes2,'Aero drag','Momentum','Total removal force','Van der Waals')


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sliderval2 = num2str(get(hObject,'Value'));
assignin('base','sliderva2l',sliderval2);
set(handles.text4,'String',num2str(sliderval2));


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

sliderval3 = num2str(get(hObject,'Value'));
assignin('base','sliderval3',sliderval3);
set(handles.text5,'String',num2str(sliderval3));


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
