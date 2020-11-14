function varargout = beer_calculator(varargin)
%BEER_CALCULATOR MATLAB code file for beer_calculator.fig
%      BEER_CALCULATOR, by itself, creates a new BEER_CALCULATOR or raises the existing
%      singleton*.
%
%      H = BEER_CALCULATOR returns the handle to a new BEER_CALCULATOR or the handle to
%      the existing singleton*.
%
%      BEER_CALCULATOR('Property','Value',...) creates a new BEER_CALCULATOR using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to beer_calculator_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      BEER_CALCULATOR('CALLBACK') and BEER_CALCULATOR('CALLBACK',hObject,...) call the
%      local function named CALLBACK in BEER_CALCULATOR.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help beer_calculator

% Last Modified by GUIDE v2.5 27-Mar-2018 23:42:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @beer_calculator_OpeningFcn, ...
                   'gui_OutputFcn',  @beer_calculator_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before beer_calculator is made visible.
function beer_calculator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for beer_calculator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes beer_calculator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = beer_calculator_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in grainBox1.
function grainBox1_Callback(hObject, eventdata, handles)
% hObject    handle to grainBox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grainBox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grainBox1
contents          = cellstr(get(hObject, 'String'));
grainBox1Value    = lower(contents{get(hObject, 'Value')});

switch grainBox1Value
    case 'pale'
        handles.grain1ColorValue = 1.2;
        handles.grain1GU         = 37;
        handles.grain1Eff        = .71;
    case 'amber'
        handles.grain1ColorValue = 35;
        handles.grain1GU         = 37;
        handles.grain1Eff        = .65;
    case 'brown'
        handles.grain1ColorValue = 35;
        handles.grain1GU         = 37;
        handles.grain1Eff        = .65;
    case 'black'
        handles.grain1ColorValue = 500;
        handles.grain1GU         = 33;
        handles.grain1Eff        = .65;
    case 'chocolate'
        handles.grain1ColorValue = 395;
        handles.grain1GU         = 33;
        handles.grain1Eff        = .65;
    case 'wheat'
        handles.grain1ColorValue = 3;
        handles.grain1GU         = 40;
        handles.grain1Eff        = .7;
end

handles.grainColor1.String = sprintf('%0.1f', handles.grain1ColorValue);

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function grainBox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainBox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.grain1ColorValue = 0;
handles.grain1GU         = 0;
handles.grain1Eff        = 0;
guidata(hObject, handles)

function beerVolume_Callback(hObject, eventdata, handles)
% hObject    handle to beerVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beerVolume as text
%        str2double(get(hObject,'String')) returns contents of beerVolume as a double

value = str2double(get(hObject,'String'));

if isnan(value)
    value = 0;
end
handles.beerVolumeValue = value;

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function beerVolume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beerVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.beerVolumeValue = 0;

guidata(hObject, handles)


function grainAmount1_Callback(hObject, eventdata, handles)
% hObject    handle to grainAmount1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grainAmount1 as text
%        str2double(get(hObject,'String')) returns contents of grainAmount1 as a double

value = str2double(get(hObject,'String'));

if isnan(value)
    value = 0;
end

handles.grainAmount1Value = value;

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function grainAmount1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainAmount1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.grainAmount1Value = 0;
guidata(hObject, handles)

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over grainAmount1.
function grainAmount1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to grainAmount1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function grainAmount2_Callback(hObject, eventdata, handles)
% hObject    handle to grainAmount2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grainAmount2 as text
%        str2double(get(hObject,'String')) returns contents of grainAmount2 as a double
value = str2double(get(hObject,'String'));

if isnan(value)
    value = 0;
end

handles.grainAmount2Value = value;
handles = updateHandles( handles );
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function grainAmount2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainAmount2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.grainAmount2Value = 0;
guidata(hObject, handles)


function grainAmount3_Callback(hObject, eventdata, handles)
% hObject    handle to grainAmount3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grainAmount3 as text
%        str2double(get(hObject,'String')) returns contents of grainAmount3 as a double
value = str2double(get(hObject,'String'));

if isnan(value)
    value = 0;
end

handles.grainAmount3Value = value;

handles = updateHandles( handles );
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function grainAmount3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainAmount3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.grainAmount3Value = 0;
guidata(hObject, handles)


function grainAmount4_Callback(hObject, eventdata, handles)
% hObject    handle to grainAmount4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grainAmount4 as text
%        str2double(get(hObject,'String')) returns contents of grainAmount4 as a double
value = str2double(get(hObject,'String'));

if isnan(value)
    value = 0;
end

handles.grainAmount4Value = value;

handles = updateHandles( handles );
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function grainAmount4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainAmount4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.grainAmount4Value = 0;
guidata(hObject, handles)

function hopsAmount1_Callback(hObject, eventdata, handles)
% hObject    handle to hopsAmount1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hopsAmount1 as text
%        str2double(get(hObject,'String')) returns contents of hopsAmount1 as a double
value = str2double(get(hObject,'String'));

if isnan(value)
    value = 0;
end
handles.hopsAmount1Value = value;

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function hopsAmount1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopsAmount1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.hopsAmount1Value = 0;

guidata(hObject, handles)


function hopsUtilization1_Callback(hObject, eventdata, handles)
% hObject    handle to hopsUtilization1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hopsUtilization1 as text
%        str2double(get(hObject,'String')) returns contents of hopsUtilization1 as a double


% --- Executes during object creation, after setting all properties.
function hopsUtilization1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopsUtilization1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function hopsAmount2_Callback(hObject, eventdata, handles)
% hObject    handle to hopsAmount2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hopsAmount2 as text
%        str2double(get(hObject,'String')) returns contents of hopsAmount2 as a double
value = str2double(get(hObject,'String'));

if isnan(value)
    value = 0;
end
handles.hopsAmount2Value = value;

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function hopsAmount2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopsAmount2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.hopsAmount2Value = 0;

guidata(hObject, handles)


function hopsUtilization2_Callback(hObject, eventdata, handles)
% hObject    handle to hopsUtilization2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hopsUtilization2 as text
%        str2double(get(hObject,'String')) returns contents of hopsUtilization2 as a double


% --- Executes during object creation, after setting all properties.
function hopsUtilization2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopsUtilization2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function hopsAmount3_Callback(hObject, eventdata, handles)
% hObject    handle to hopsAmount3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hopsAmount3 as text
%        str2double(get(hObject,'String')) returns contents of hopsAmount3 as a double
value = str2double(get(hObject,'String'));

if isnan(value)
    value = 0;
end
handles.hopsAmount3Value = value;

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function hopsAmount3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopsAmount3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.hopsAmount3Value = 0;

guidata(hObject, handles)


function hopsUtilization3_Callback(hObject, eventdata, handles)
% hObject    handle to hopsUtilization3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hopsUtilization3 as text
%        str2double(get(hObject,'String')) returns contents of hopsUtilization3 as a double


% --- Executes during object creation, after setting all properties.
function hopsUtilization3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopsUtilization3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function grainColor1_Callback(hObject, eventdata, handles)
% hObject    handle to grainColor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grainColor1 as text
%        str2double(get(hObject,'String')) returns contents of grainColor1 as a double


% --- Executes during object creation, after setting all properties.
function grainColor1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainColor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function grainColor2_Callback(hObject, eventdata, handles)
% hObject    handle to grainColor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grainColor2 as text
%        str2double(get(hObject,'String')) returns contents of grainColor2 as a double


% --- Executes during object creation, after setting all properties.
function grainColor2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainColor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function grainColor3_Callback(hObject, eventdata, handles)
% hObject    handle to grainColor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grainColor3 as text
%        str2double(get(hObject,'String')) returns contents of grainColor3 as a double


% --- Executes during object creation, after setting all properties.
function grainColor3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainColor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function grainColor4_Callback(hObject, eventdata, handles)
% hObject    handle to grainColor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grainColor4 as text
%        str2double(get(hObject,'String')) returns contents of grainColor4 as a double


% --- Executes during object creation, after setting all properties.
function grainColor4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainColor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in grainBox2.
function grainBox2_Callback(hObject, eventdata, handles)
% hObject    handle to grainBox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grainBox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grainBox2
contents          = cellstr(get(hObject, 'String'));
grainBox2Value    = lower(contents{get(hObject, 'Value')});

switch grainBox2Value
    case 'pale'
        handles.grain2ColorValue = 1.2;
        handles.grain2GU         = 37;
        handles.grain2Eff        = .71;
    case 'amber'
        handles.grain2ColorValue = 35;
        handles.grain2GU         = 37;
        handles.grain2Eff        = .65;
    case 'brown'
        handles.grain2ColorValue = 35;
        handles.grain2GU         = 37;
        handles.grain2Eff        = .65;
    case 'black'
        handles.grain2ColorValue = 500;
        handles.grain2GU         = 33;
        handles.grain2Eff        = .65;
    case 'chocolate'
        handles.grain2ColorValue = 395;
        handles.grain2GU         = 33;
        handles.grain2Eff        = .65;
    case 'wheat'
        handles.grain2ColorValue = 3;
        handles.grain2GU         = 40;
        handles.grain2Eff        = .7;
end
handles.grainColor2.String = sprintf('%0.1f', handles.grain2ColorValue);

handles = updateHandles( handles );
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function grainBox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainBox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.grain2ColorValue = 0;
handles.grain2GU         = 0;
handles.grain2Eff        = 0;
guidata(hObject, handles)

% --- Executes on selection change in grainBox3.
function grainBox3_Callback(hObject, eventdata, handles)
% hObject    handle to grainBox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grainBox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grainBox3
contents          = cellstr(get(hObject, 'String'));
grainBox3Value    = lower(contents{get(hObject, 'Value')});

switch grainBox3Value
    case 'pale'
        handles.grain3ColorValue = 1.2;
        handles.grain3GU         = 37;
        handles.grain3Eff        = .71;
    case 'amber'
        handles.grain3ColorValue = 35;
        handles.grain3GU         = 37;
        handles.grain3Eff        = .65;
    case 'brown'
        handles.grain3ColorValue = 35;
        handles.grain3GU         = 37;
        handles.grain3Eff        = .65;
    case 'black'
        handles.grain3ColorValue = 500;
        handles.grain3GU         = 33;
        handles.grain3Eff        = .65;
    case 'chocolate'
        handles.grain3ColorValue = 395;
        handles.grain3GU         = 33;
        handles.grain3Eff        = .65;
    case 'wheat'
        handles.grain3ColorValue = 3;
        handles.grain3GU         = 40;
        handles.grain3Eff        = .7;
end
handles.grainColor3.String = sprintf('%0.1f', handles.grain3ColorValue);

handles = updateHandles( handles );
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function grainBox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainBox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.grain3ColorValue = 0;
handles.grain3GU         = 0;
handles.grain3Eff        = 0;
guidata(hObject, handles)

% --- Executes on selection change in grainBox4.
function grainBox4_Callback(hObject, eventdata, handles)
% hObject    handle to grainBox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grainBox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grainBox4
contents          = cellstr(get(hObject, 'String'));
grainBox4Value    = lower(contents{get(hObject, 'Value')});

switch grainBox4Value
    case 'pale'
        handles.grain3ColorValue = 1.2;
        handles.grain3GU         = 37;
        handles.grain3Eff        = .71;
    case 'amber'
        handles.grain3ColorValue = 35;
        handles.grain3GU         = 37;
        handles.grain3Eff        = .65;
    case 'brown'
        handles.grain3ColorValue = 35;
        handles.grain3GU         = 37;
        handles.grain3Eff        = .65;
    case 'black'
        handles.grain3ColorValue = 500;
        handles.grain3GU         = 33;
        handles.grain3Eff        = .65;
    case 'chocolate'
        handles.grain3ColorValue = 395;
        handles.grain3GU         = 33;
        handles.grain3Eff        = .65;
    case 'wheat'
        handles.grain3ColorValue = 3;
        handles.grain3GU         = 40;
        handles.grain3Eff        = .7;
end
handles.grainColor4.String = sprintf('%0.1f', handles.grain4ColorValue);

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function grainBox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grainBox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.grain4ColorValue = 0;
handles.grain4GU         = 0;
handles.grain4Eff        = 0;
guidata(hObject, handles)

% --- Executes on selection change in hopsMenu1.
function hopsMenu1_Callback(hObject, eventdata, handles)
% hObject    handle to hopsMenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hopsMenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hopsMenu1
contents  = cellstr(get(hObject, 'String'));
hopsMenu1 = lower(contents{get(hObject, 'Value')});

switch hopsMenu1
    case 'cascade'
        handles.hopsMenu1AA = 7.5;
    case 'centennial'
        handles.hopsMenu1AA = 12;
    case 'columbus'
        handles.hopsMenu1AA = 16;
    case 'galena'
        handles.hopsMenu1AA = 14;
    case 'tettnang'
        handles.hopsMenu1AA = 3.5;
    case 'saaz'
        handles.hopsMenu1AA = 2;
    case 'willamette'
        handles.hopsMenu1AA = 5;
end

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function hopsMenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopsMenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.hopsMenu1AA = 0;
guidata(hObject, handles)

% --- Executes on selection change in hopsMenu2.
function hopsMenu2_Callback(hObject, eventdata, handles)
% hObject    handle to hopsMenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hopsMenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hopsMenu2
contents  = cellstr(get(hObject, 'String'));
hopsMenu2 = lower(contents{get(hObject, 'Value')});

switch hopsMenu2
    case 'cascade'
        handles.hopsMenu2AA = 7.5;
    case 'centennial'
        handles.hopsMenu2AA = 12;
    case 'columbus'
        handles.hopsMenu2AA = 16;
    case 'galena'
        handles.hopsMenu2AA = 14;
    case 'tettnang'
        handles.hopsMenu2AA = 3.5;
    case 'saaz'
        handles.hopsMenu2AA = 2;
    case 'willamette'
        handles.hopsMenu2AA = 5;
end

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function hopsMenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopsMenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.hopsMenu2AA = 0;
guidata(hObject, handles)

% --- Executes on selection change in hopsMenu3.
function hopsMenu3_Callback(hObject, eventdata, handles)
% hObject    handle to hopsMenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hopsMenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hopsMenu3
contents  = cellstr(get(hObject, 'String'));
hopsMenu3 = lower(contents{get(hObject, 'Value')});

switch hopsMenu3
    case 'cascade'
        handles.hopsMenu3AA = 7.5;
    case 'centennial'
        handles.hopsMenu3AA = 12;
    case 'columbus'
        handles.hopsMenu3AA = 16;
    case 'galena'
        handles.hopsMenu3AA = 14;
    case 'tettnang'
        handles.hopsMenu3AA = 3.5;
    case 'saaz'
        handles.hopsMenu3AA = 2;
    case 'willamette'
        handles.hopsMenu3AA = 5;
end

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function hopsMenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopsMenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.hopsMenu3AA = 0;
guidata(hObject, handles)

% --- Executes on slider movement.
function utilizationSlider1_Callback(hObject, eventdata, handles)
% hObject    handle to utilizationSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.utilization1 = get(hObject,'Value');
handles.slider1Value.String = sprintf('%0.2f', handles.utilization1);

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function utilizationSlider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to utilizationSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
handles.utilization1 = 0;
guidata(hObject, handles)

% --- Executes on slider movement.
function utilizationSlider2_Callback(hObject, eventdata, handles)
% hObject    handle to utilizationSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.utilization2 = get(hObject,'Value');
handles.slider2Value.String = sprintf('%0.2f', handles.utilization2);

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function utilizationSlider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to utilizationSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
handles.utilization2 = 0;
guidata(hObject, handles)

% --- Executes on slider movement.
function utilizationSlider3_Callback(hObject, eventdata, handles)
% hObject    handle to utilizationSlider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.utilization3 = get(hObject,'Value');
handles.slider3Value.String = sprintf('%0.2f', handles.utilization3);

handles = updateHandles( handles );
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function utilizationSlider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to utilizationSlider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
handles.utilization3 = 0;
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function slider1Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function alcoholOutput_Callback(hObject, eventdata, handles)
% hObject    handle to alcoholOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alcoholOutput as text
%        str2double(get(hObject,'String')) returns contents of alcoholOutput as a double


% --- Executes during object creation, after setting all properties.
function alcoholOutput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alcoholOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ColorOutput_Callback(hObject, eventdata, handles)
% hObject    handle to ColorOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ColorOutput as text
%        str2double(get(hObject,'String')) returns contents of ColorOutput as a double


% --- Executes during object creation, after setting all properties.
function ColorOutput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ColorOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IBUOutput_Callback(hObject, eventdata, handles)
% hObject    handle to IBUOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IBUOutput as text
%        str2double(get(hObject,'String')) returns contents of IBUOutput as a double


% --- Executes during object creation, after setting all properties.
function IBUOutput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IBUOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
