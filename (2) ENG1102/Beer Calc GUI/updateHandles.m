function handles = updateHandles( handles )
%calculates the stuff
    
    beerAlcohol    = alcohol(handles);
    beerColor      = maltColor(handles);
    beerBitterness = bitterness(handles);
    
    handles.alcoholOutput.String = sprintf('%0.2f', beerAlcohol);
    handles.ColorOutput.String    = sprintf('%0.2f', beerColor);
    handles.IBUOutput.String      = sprintf('%0.2f', beerBitterness);

    function ABV = alcohol(handles)
        %finds the %alcohol of the beer
        grain1GUTot = handles.grainAmount1Value * handles.grain1GU * handles.grain1Eff;
        grain2GUTot = handles.grainAmount2Value * handles.grain2GU * handles.grain2Eff;
        grain3GUTot = handles.grainAmount3Value * handles.grain3GU * handles.grain3Eff;
        grain4GUTot = handles.grainAmount4Value * handles.grain4GU * handles.grain4Eff;
        
        GUTotal = grain1GUTot + grain2GUTot + grain3GUTot + grain4GUTot;
        
        GUDesign = GUTotal / handles.beerVolumeValue;
        
        SGOriginal = (GUDesign / 1000) + 1;
        
        ABV = (SGOriginal - 1.01) * 131.25;
    end

    function standardColor = maltColor(handles)
        %calculates the SRM of the beer
        maltColor1 = handles.grain1ColorValue * handles.grainAmount1Value / handles.beerVolumeValue;
        maltColor2 = handles.grain2ColorValue * handles.grainAmount2Value / handles.beerVolumeValue;
        maltColor3 = handles.grain3ColorValue * handles.grainAmount3Value / handles.beerVolumeValue;
        maltColor4 = handles.grain4ColorValue * handles.grainAmount4Value / handles.beerVolumeValue;
        
        maltColorTotal = maltColor1 + maltColor2 + maltColor3 + maltColor4;
        
        standardColor = (0.204 * maltColorTotal) + 2;
    end

    function beerBitterness = bitterness(handles)
        %calculates the IBU of the beer
        bitterness1 = handles.hopsAmount1Value *  handles.hopsMenu1AA * handles.utilization1 * 7489 / handles.beerVolumeValue;
        bitterness2 = handles.hopsAmount2Value *  handles.hopsMenu2AA * handles.utilization2 * 7489 / handles.beerVolumeValue;
        bitterness3 = handles.hopsAmount3Value *  handles.hopsMenu3AA * handles.utilization3 * 7489 / handles.beerVolumeValue;
        
        beerBitterness = bitterness1 + bitterness2 + bitterness3;
    end
end

