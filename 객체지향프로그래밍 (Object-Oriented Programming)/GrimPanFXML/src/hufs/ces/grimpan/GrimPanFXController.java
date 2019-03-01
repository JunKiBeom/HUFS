package hufs.ces.grimpan;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import javax.swing.JColorChooser;

import javafx.application.Platform;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.geometry.Point2D;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.CheckMenuItem;
import javafx.scene.control.ChoiceDialog;
import javafx.scene.control.MenuItem;
import javafx.scene.control.RadioMenuItem;
import javafx.scene.control.TextInputDialog;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.Path;
import javafx.scene.shape.Shape;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;
import javafx.stage.Stage;

public class GrimPanFXController extends AnchorPane{

	public Stage parentStage;
	private GrimPanModel model;
	private ShapeFactory sf;
	
	DoubleProperty widthProp = new SimpleDoubleProperty();
	DoubleProperty heightProp = new SimpleDoubleProperty();
	
	public GrimPanFXController() {

		model = new GrimPanModel();
		sf = new ShapeFactory(model);

		FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("grimpan1.fxml"));
		fxmlLoader.setRoot(this);
		fxmlLoader.setController(this);

		try {
			fxmlLoader.load();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		/*
		ColorPicker colorPicker = new ColorPicker(Color.BLUE);
		colorPicker.setOnAction(t->{
			Color color = colorPicker.getValue();
			model.setShapeStrokeColor(color);
		});
		Label scolorLabel =  new Label("Stroke Color", colorPicker);
		scolorLabel.setContentDisplay(ContentDisplay.RIGHT);
		scolorLabel.setStyle("-fx-padding: 0 0 0 15;");
		menuStrokeColor.setContent(scolorLabel);
		*/
		
		widthProp.bind(drawPane.widthProperty());
		heightProp.bind(drawPane.heightProperty());
		
		initDrawPane();
	}
	void initDrawPane() {
		model.shapeList.clear();
		model.curDrawShape = null;
		model.polygonPoints.clear();
		clearDrawPane();
		//System.out.format("drawPane w=%s h=%s\n", drawPane.getWidth(), drawPane.getHeight());
		//System.out.format("drawPane wp=%s hp=%s\n", drawPane.getPrefWidth(), drawPane.getPrefHeight());
	}
	
	void clearDrawPane() {
		drawPane.getChildren().clear();
	}
	void redrawDrawPane() {
		Status();
		clearDrawPane();
		//System.out.println("Shape Count="+model.shapeList.size());
		for (Shape sh:model.shapeList){
			drawPane.getChildren().add(sh);
		}
		if (model.curDrawShape!=null) {
			drawPane.getChildren().add(model.curDrawShape);
		}
	}

	@FXML
    private Pane drawPane;
	
    @FXML
    private MenuItem menuNew;

    @FXML
    private MenuItem menuOpen;

    @FXML
    private MenuItem menuSave;

    @FXML
    private MenuItem menuSaveAs;

    @FXML
    private MenuItem menuExit;

    @FXML
    private RadioMenuItem menuLine;

    @FXML
    private RadioMenuItem menuPencil;

    @FXML
    private RadioMenuItem menuPolygon;

    @FXML
    private RadioMenuItem menuRegular;

    @FXML
    private RadioMenuItem menuOval;

    @FXML
    private MenuItem menuMove;

    @FXML
    private MenuItem menuDelete;

    @FXML
    private MenuItem menuStrokeWidth;

    @FXML
    private MenuItem menuStrokeColor;

    @FXML
    private MenuItem menuFillColor;

    @FXML
    private CheckMenuItem menuCheckStroke;

    @FXML
    private CheckMenuItem menuCheckFill;

    @FXML
    private MenuItem menuAbout;

    @FXML
    void handleMenuAbout(ActionEvent event) {

		Alert alert = new Alert(AlertType.INFORMATION);
		alert.setTitle("About");
		alert.setHeaderText("GrimPan Ver 0.1.1");
		alert.setContentText("Programmed by cskim, ces, hufs.ac.kr");

		alert.showAndWait();
    }

    @FXML
    void handleMenuCheckFill(ActionEvent event) {
		CheckMenuItem checkFill = (CheckMenuItem)event.getSource();
		if (checkFill.isSelected())
			model.setShapeFill(true);
		else
			model.setShapeFill(false);
    }

    @FXML
    void handleMenuCheckStroke(ActionEvent event) {
		CheckMenuItem checkStroke = (CheckMenuItem)event.getSource();
		if (checkStroke.isSelected())
			model.setShapeStroke(true);
		else
			model.setShapeStroke(false);
    }

    @FXML
    void handleMenuDelete(ActionEvent event) {

    }

    @FXML
    void handleMenuExit(ActionEvent event) {
		Platform.exit();
    }

    @FXML
    void handleMenuFillColor(ActionEvent event) {
		java.awt.Color awtColor = 
				JColorChooser.showDialog(null, "Choose a color", java.awt.Color.BLACK);
		Color jxColor = Color.BLACK;
		if (awtColor!=null){
			jxColor = new Color(awtColor.getRed()/255.0, awtColor.getGreen()/255.0, awtColor.getBlue()/255.0, 1);
		}
		model.setShapeFillColor(jxColor);
    }

    @FXML
    void handleMenuLine(ActionEvent event) {
		model.setEditState(Utils.SHAPE_LINE);
		redrawDrawPane();
    }

    @FXML
    void handleMenuMove(ActionEvent event) {
    	model.setEditState(Utils.EDIT_MOVE);
    	if (model.curDrawShape != null){
			model.shapeList.add(model.curDrawShape);
			model.curDrawShape = null;
    	}
		redrawDrawPane();
    }

    @FXML
    void handleMenuNew(ActionEvent event) {
		initDrawPane();
    }

    @FXML
    void handleMenuOpen(ActionEvent event) {

    }

    @FXML
    void handleMenuOval(ActionEvent event) {
		model.setEditState(Utils.SHAPE_OVAL);
		redrawDrawPane();
    }

    @FXML
    void handleMenuPencil(ActionEvent event) {
		model.setEditState(Utils.SHAPE_PENCIL);
		redrawDrawPane();
    }

    @FXML
    void handleMenuPolygon(ActionEvent event) {
		model.setEditState(Utils.SHAPE_POLYGON);
		redrawDrawPane();
    }

    @FXML
    void handleMenuRegular(ActionEvent event) {
		model.setEditState(Utils.SHAPE_REGULAR);
		String[] possibleValues = { 
				"3", "4", "5", "6", "7",
				"8", "9", "10", "11", "12"
		};
		List<String> dialogData = Arrays.asList(possibleValues);

		ChoiceDialog<String> dialog = new ChoiceDialog<>(dialogData.get(0), dialogData);
		dialog.setTitle("Regular Polygon");
		dialog.setHeaderText("Number of Points");
		Optional<String> result = dialog.showAndWait();
		String selectedValue = String.valueOf(model.getNPolygon());
		if (result.isPresent()) {
			selectedValue = result.get();
		}

		model.setNPolygon(Integer.parseInt((String)selectedValue));

		redrawDrawPane();
    }

    @FXML
    void handleMenuSave(ActionEvent event) {

    }

    @FXML
    void handleMenuStrokeColor(ActionEvent event) {
		java.awt.Color awtColor = 
				JColorChooser.showDialog(null, "Choose a color", java.awt.Color.BLACK);
		Color jxColor = Color.BLACK;
		if (awtColor!=null){
			jxColor = new Color(awtColor.getRed()/255.0, awtColor.getGreen()/255.0, awtColor.getBlue()/255.0, 1);
		}
		model.setShapeStrokeColor(jxColor);
    }

    @FXML
    void handleMenuStrokeWidth(ActionEvent event) {
		TextInputDialog dialog = new TextInputDialog("10");
		dialog.setTitle("Set Stroke Width");
		dialog.setHeaderText("Enter Stroke Width Value");
		Optional<String> result = dialog.showAndWait();
		if (result.isPresent()) {
			String inputVal = result.get();
			model.setShapeStrokeWidth(Float.parseFloat(inputVal));
		}

    }

    @FXML
    void handleMenusaveAs(ActionEvent event) {

    }

    @FXML
    void handleMouseEntered(MouseEvent event) {
    	model.setMouseInside(true);
    }

    @FXML
    void handleMouseExited(MouseEvent event) {
    	model.setMouseInside(false);
    }
    
    @FXML TextFlow Status;
    @FXML TextFlow Size;
    void Status()
    {
    	Status.getChildren().clear();
    	Size.getChildren().clear();
    	String H = String.valueOf(heightProp.get());
    	String W = String.valueOf(widthProp.get());
    	Text h = new Text(H);
    	Text w = new Text(W);
    	Size.getChildren().addAll(new Text("Size : "),w,new Text(" * "),h);
    	Text St=new Text();
    	if (model.getEditState()==0)
    		St.setText("정다각형");
    	else if (model.getEditState()==1)
    		St.setText("타원형");
    	else if (model.getEditState()==2)
    		St.setText("다각형");
    	else if (model.getEditState()==3)
    		St.setText("선분");
    	else if (model.getEditState()==4)
    		St.setText("연필");
    	else if (model.getEditState()==5)
    		St.setText("이동");
    	Status.getChildren().addAll(new Text("Status : "),St);
    	//System.out.println(model.getEditState());
    }

    @FXML
    void handleMouseDragged(MouseEvent event) {
		Point2D p1 = new Point2D(Math.max(0, event.getX()), Math.max(0, event.getY()));

		if (event.getButton()==MouseButton.PRIMARY && model.isMouseInside()){
			model.setPrevMousePosition(model.getCurrMousePosition());
			model.setCurrMousePosition(p1);

			switch (model.getEditState()){
			case Utils.SHAPE_LINE:
				model.curDrawShape = sf.createMousePointedLine();
				break;
			case Utils.SHAPE_PENCIL:
				((Path)model.curDrawShape).getElements().add(new LineTo(p1.getX(), p1.getY()));
				break;
			case Utils.SHAPE_POLYGON:
				break;
			case Utils.SHAPE_REGULAR:
				model.curDrawShape = sf.createRegularPolygon(model.getNPolygon());
				break;
			case Utils.SHAPE_OVAL:
				model.curDrawShape = sf.createMousePointedEllipse();
				break;
			case Utils.EDIT_MOVE:
				moveShapeByMouse();
				break;

			}
		}
		redrawDrawPane();
    }

    @FXML
    void handleMousePressed(MouseEvent event) {
    	System.out.format("drawPane %s * %s\n", drawPane.getWidth(), drawPane.getHeight());
    	//Status();
		Point2D p1 = new Point2D(Math.max(0, event.getX()), Math.max(0, event.getY()));

		if (event.getButton()==MouseButton.PRIMARY && model.isMouseInside()){
			model.setStartMousePosition(p1);
			model.setCurrMousePosition(p1);
			model.setPrevMousePosition(p1);				
			switch (model.getEditState()){
			case Utils.SHAPE_LINE:
				model.curDrawShape = sf.createMousePointedLine();
				break;
			case Utils.SHAPE_PENCIL:
				model.curDrawShape = sf.createPaintedShape(new Path(new MoveTo(p1.getX(), p1.getY())));
				break;
			case Utils.SHAPE_POLYGON:
				model.polygonPoints.add(model.getCurrMousePosition());
				if (event.isShiftDown()) {
					model.curDrawShape = sf.createPolygonFromClickedPoints();
					model.polygonPoints.clear();
					model.shapeList.add(model.curDrawShape);
					model.curDrawShape = null;
				}
				else {
					model.curDrawShape = sf.createPolylineFromClickedPoints();
				}
				break;
			case Utils.SHAPE_REGULAR:
				model.curDrawShape = sf.createRegularPolygon(model.getNPolygon());
				break;
			case Utils.SHAPE_OVAL:
				model.curDrawShape = sf.createMousePointedEllipse();
				break;
			case Utils.EDIT_MOVE:
				getSelectedShape();
				break;
			}
		}
		redrawDrawPane();
    }

    @FXML
    void handleMouseReleased(MouseEvent event) {
		
		Point2D p1 = new Point2D(Math.max(0, event.getX()), Math.max(0, event.getY()));
		//System.out.println("Mouse Released at "+p1);

		if (event.getButton()==MouseButton.PRIMARY){
			model.setPrevMousePosition(model.getCurrMousePosition());
			model.setCurrMousePosition(p1);

			switch (model.getEditState()){
			case Utils.SHAPE_LINE:
				model.curDrawShape = sf.createMousePointedLine();
				if (model.curDrawShape != null){
					model.shapeList.add(model.curDrawShape);
					model.curDrawShape = null;
				}
				break;
			case Utils.SHAPE_PENCIL:
				((Path)model.curDrawShape).getElements().add(new LineTo(p1.getX(), p1.getY()));
				if (model.curDrawShape != null){
					model.shapeList.add(model.curDrawShape);
					model.curDrawShape = null;
				}
				break;
			case Utils.SHAPE_POLYGON:
				break;
			case Utils.SHAPE_REGULAR:
				model.curDrawShape = sf.createRegularPolygon(model.getNPolygon());
				if (model.curDrawShape != null){
					model.shapeList.add(model.curDrawShape);
					model.curDrawShape = null;
				}
				break;
			case Utils.SHAPE_OVAL:
				model.curDrawShape = sf.createMousePointedEllipse();
				if (model.curDrawShape != null){
					model.shapeList.add(model.curDrawShape);
					model.curDrawShape = null;
				}
				break;
			case Utils.EDIT_MOVE:
				endShapeMove();
				break;

			}
		}
    }

    private void getSelectedShape(){
		int selIndex = -1;
		Shape shape = null;
		for (int i=model.shapeList.size()-1; i >= 0; --i){
			shape = model.shapeList.get(i);
			if (shape.contains(model.getStartMousePosition().getX(), model.getStartMousePosition().getY())){
				selIndex = i;
				break;
			}
		}
		if (selIndex != -1){
			Color scolor = (Color)shape.getStroke();
			Color fcolor = (Color)shape.getFill();
			if (shape.getStroke()!=Color.TRANSPARENT){
				shape.setStroke(new Color (scolor.getRed(), scolor.getGreen(), scolor.getBlue(), 0.5));
			}
			if (shape.getFill()!=Color.TRANSPARENT){
				shape.setFill(new Color (fcolor.getRed(), fcolor.getGreen(), fcolor.getBlue(), 0.5));
			}
		}
		model.setSelectedShape(selIndex);
	}
	private void moveShapeByMouse(){
		int selIndex = model.getSelectedShape();
		Shape shape = null;
		if (selIndex != -1){
			shape = model.shapeList.get(selIndex);
			double dx = model.getCurrMousePosition().getX() - model.getPrevMousePosition().getX();
			double dy = model.getCurrMousePosition().getY() - model.getPrevMousePosition().getY();

			ShapeFactory.translateShape(shape, dx, dy);
		}
	}
	private void endShapeMove(){
		int selIndex = model.getSelectedShape();
		Shape shape = null;
		if (selIndex != -1){
			shape = model.shapeList.get(selIndex);
			Color scolor = (Color)shape.getStroke();
			Color fcolor = (Color)shape.getFill();
			if (shape.getStroke()!=Color.TRANSPARENT){
				shape.setStroke(new Color (scolor.getRed(), scolor.getGreen(), scolor.getBlue(), 1));
			}
			if (shape.getFill()!=Color.TRANSPARENT){
				shape.setFill(new Color (fcolor.getRed(), fcolor.getGreen(), fcolor.getBlue(), 1));
			}
			double dx = model.getCurrMousePosition().getX() - model.getPrevMousePosition().getX();
			double dy = model.getCurrMousePosition().getY() - model.getPrevMousePosition().getY();

			ShapeFactory.translateShape(shape, dx, dy);
		}
	}
}
