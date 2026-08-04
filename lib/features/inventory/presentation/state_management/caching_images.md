# The Importance of Caching

## For the future me

`Problem`: Caching this decoded images is important as we can prevent the flickering image glitch that sometimes happen when scrolling or clicking something that triggers the widget to rebuild. This is because the image is being decoded every time the widget is rebuilt. By caching the decoded image, we can avoid this issue.

`Solution`: Instead of letting a dumb widget process the decoding of an image string, we move the decoding part to the state management at the part where the data [ProductModel] was being freshly fetched from the backend [Firebase] we then decode images of each product and store it in a provider with [Map<String, Uint8List>] data structure. Then smart widget passes those decoded image to its child (the dumb widget).

`This is written as of August 4, 2026 at 9:40pm`
