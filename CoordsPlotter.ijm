// Define the directory containing .vsi images
dir = getDirectory("Choose a Directory");

// Get the list of files in the directory
list = getFileList(dir);

// Initialize arrays to store image names and coordinates
imageNames = newArray();
xCoords = newArray();
yCoords = newArray();

// Create a string to store the CSV content
csvContent = "Image Name,X Coordinate,Y Coordinate\n";

// Function to parse metadata and extract coordinates
function parseMetadata(metadata) {
    lines = split(metadata, "\n");
    x = NaN;
    y = NaN;
    for (a = 0; a < lines.length; a++) {
        if (startsWith(lines[a], "Origin = ")) {
            // Extract the coordinates from the line
            originLine = lines[a];
            originLine = replace(originLine, "Origin = \\(", "");
            originLine = replace(originLine, "\\)", "");
            coords = split(originLine, ", ");
            x = parseFloat(coords[0]);
            y = parseFloat(coords[1]);
        }
    }
    return newArray(x, y);
}

// Utility function to find the maximum and maximum value in an array
function maxOf(arr) {
    maxVal = arr[0];
    for (j = 1; j < arr.length; j++) {
        if (arr[j] > maxVal) {
            maxVal = arr[j];
        }
    }
    return maxVal;
}

function minOf(arr) {
    minVal = arr[0];
    for (j = 1; j < arr.length; j++) {
        if (arr[j] < minVal) {
            minVal = arr[j];
        }
    }
    return minVal;
}

index = 0; // Index to keep track of the number of valid images processed

for (i = 0; i < list.length; i++) {
    filename = dir + list[i];

    if (endsWith(filename, ".vsi")) {
        run("Bio-Formats Importer", "open=[" + filename + "] autoscale color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT series_1");

        // Extract the image name (without extension)
        ImageID = File.name;
        imageName = substring(ImageID, 0, lengthOf(ImageID)-4);

        imageList = getList("image.titles");

        // Loop through the image list to find and select the BF channel (C=0)
        for (j=0; j<imageList.length; j++) {
            if (matches(imageList[j], ImageID + ".* - C=0.*")) {
                selectImage(imageList[j]);
                metadata = getMetadata("Info");
                coords = parseMetadata(metadata);

                if (!isNaN(coords[0]) && !isNaN(coords[1])) {
                    xCoords = Array.concat(xCoords, coords[0]);
                    yCoords = Array.concat(yCoords, coords[1]);
                    imageNames = Array.concat(imageNames, imageName);

                    csvContent += imageName + "," + coords[0] + "," + coords[1] + "\n";
                    print(imageName + "," + coords[0] + "," + coords[1] + "\n");

                    index++;
                }
                close("*");
            }
        }
    }
}

// Find the minimum and maximum x and y coordinates
minX = minOf(xCoords);
minY = minOf(yCoords);
maxX = maxOf(xCoords);
maxY = maxOf(yCoords);

// Add padding to avoid points being too close to the edges
padding = 30;

// Calculate the range of coordinates
rangeX = maxX - minX;
rangeY = maxY - minY;

// Adjust the coordinates to fit within the plot area with padding
adjustedXCoords = newArray(xCoords.length);
adjustedYCoords = newArray(yCoords.length);

for (i = 0; i < xCoords.length; i++) {
    adjustedXCoords[i] = ((xCoords[i] - minX) / rangeX) * (1024 - 2 * padding) + padding;
    adjustedYCoords[i] = ((yCoords[i] - minY) / rangeY) * (1024 - 2 * padding) + padding;
    
    // Print the adjusted coordinates
    // print("Image: " + imageNames[i] + " | Adjusted X: " + adjustedXCoords[i] + " | Adjusted Y: " + adjustedYCoords[i]);
}

// Plot the coordinates
newImage("Coordinates Plot", "RGB black", 1024, 1024, 1);
 
// Draw a blue rectangle to indicate the padding area
setColor("blue");
drawRect(padding, padding, 1024 - 2 * padding, 1024 - 2 * padding);

// Plot each point and label it
setColor("red");

for (i = 0; i < adjustedXCoords.length; i++) {
    
    // Plot the point
    drawOval(adjustedXCoords[i], adjustedYCoords[i], 5, 5);

    // Calculate the string position, adjusting to avoid it going off the edge
    textX = adjustedXCoords[i] + 6;
    textY = adjustedYCoords[i];
    
    // Adjust if the text would go off the right edge
    if (textX + 15 > 1024) {  // Assuming the text width is around 100 pixels
        textX = adjustedXCoords[i] - 15;  // Move the text to the left
    }
    
    // Extract the last 3 characters of the image name
    label = substring(imageNames[i], lengthOf(imageNames[i]) - 3, lengthOf(imageNames[i]));

    // Label the point with the image name
    drawString(label, textX, textY);
}

// Save the plot
saveAs("jpeg", dir + "Coordinates_Plot.jpeg");
run("Close All");

// Save the CSV file
csvPath = dir + "image_coordinates.csv";
File.saveString(csvContent, csvPath);
print("CSV file saved to: " + csvPath);
