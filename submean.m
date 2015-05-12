function varargout = submean(varargin)
% SUBMEAN MATLAB code for submean.fig
%      SUBMEAN, by itself, creates a new SUBMEAN or raises the existing
%      singleton*.
%
%      H = SUBMEAN returns the handle to a new SUBMEAN or the handle to
%      the existing singleton*.
%
%      SUBMEAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUBMEAN.M with the given input arguments.
%
%      SUBMEAN('Property','Value',...) creates a new SUBMEAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before submean_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to submean_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help submean

% Last Modified by GUIDE v2.5 23-Apr-2013 16:26:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @submean_OpeningFcn, ...
    'gui_OutputFcn',  @submean_OutputFcn, ...
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


% --- Executes just before submean is made visible.
function submean_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to submean (see VARARGIN)

% Choose default command line output for submean
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes submean wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = submean_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global resultsfolder files name nof

resultsfolder = get(handles.edit1,'String');

fmt_s = imformats('tif');

cd(resultsfolder);
addpath(resultsfolder);

out = uipickfiles;
name = out{1};
set(handles.text1,'String',name);
cd(name);

files = dir('*.tif');
nof = length(files);

im = double(myimread(files(1).name,fmt_s));

axes(handles.axes1);
imshow(im,[min(min(im)) max(max(im))]);

set(handles.slider1,'Value',1);
set(handles.slider1,'Min',1);
set(handles.slider1,'Max',nof);
set(handles.slider1,'Value',1);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global resultsfolder files name nof

fmt_s = imformats('tif');

frnumb = round(get(handles.slider1,'Value'));

set(handles.text2,'String',num2str(frnumb));

im = double(myimread(files(frnumb).name,fmt_s));

axes(handles.axes1);
imshow(im,[min(min(im)) max(max(im))]);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global resultsfolder files name nof

fmt_s = imformats('tif');

slwin = str2num(get(handles.edit2,'String'));

imr = double(myimread(files(1).name,fmt_s));

% nof = 200;

for j=1:nof
    j
    in = 0;
    meanim(:,:,j) = zeros(size(imr));
    minim = j-slwin;
    maxim = j+slwin;
    if(minim < 1)
        maxim = 2*slwin
        minim = 1;
    end
    if(maxim > nof)
        minim = nof-2*slwin;
        maxim = nof;
    end
    minim
    maxim
    pause(0.5)
    for i=minim:maxim
        im = double(myimread(files(i).name,fmt_s));
        meanim(:,:,j) = meanim(:,:,j) + im;
        in = in + 1;
    end
    meanim(:,:,j) = meanim(:,:,j)./in;
    
end



cd('..');
mkdir(['subtracted']);

cd('subtracted');

for i=1:nof
    i
    imsub = double(myimread([name,'\',files(i).name],fmt_s)) - double(meanim(:,:,i));
    imwrite(uint16(imsub),['sub_',files(i).name]);
    imwrite(uint16(meanim(:,:,i)),['corr_',files(i).name]);
end

rmpath(resultsfolder);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
