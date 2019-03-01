package hufs.ces.grimpan;

import java.io.File;
import java.util.ArrayList;

import javafx.geometry.Point2D;
import javafx.scene.paint.Color;
import javafx.scene.shape.Shape;

public class GrimPanModel {

	private int editState = Utils.SHAPE_PENCIL;

	
	private float shapeStrokeWidth = 10f;
	private Color shapeStrokeColor = Color.BLACK;
	private boolean shapeStroke = true;
	private boolean shapeFill = false;
	private Color shapeFillColor = null;
	
	private Point2D startMousePosition = null;
	private Point2D currMousePosition = null;
	private Point2D prevMousePosition = null;
	
	private boolean mouseInside = false;
	
	private int selectedShape = -1;
	
	private int nPolygon = 3;
	
	private File saveFile = null;

	public ArrayList<Shape> shapeList = null;
	public Shape curDrawShape = null;
	public ArrayList<Point2D> polygonPoints = null;
	
	public GrimPanModel(){
		this.shapeList = new ArrayList<Shape>();
		this.shapeStrokeColor = Color.BLACK;
		this.shapeFillColor = Color.TRANSPARENT;
		this.polygonPoints = new ArrayList<Point2D>();
	}

	public int getEditState() {
		return editState;
	}

	public void setEditState(int editState) {
		this.editState = editState;
	}
	
	

	public float getShapeStrokeWidth() {
		return shapeStrokeWidth;
	}

	public void setShapeStrokeWidth(float shapeStrokeWidth) {
		this.shapeStrokeWidth = shapeStrokeWidth;
	}

	public Color getShapeStrokeColor() {
		return shapeStrokeColor;
	}

	public void setShapeStrokeColor(Color shapeStrokeColor) {
		this.shapeStrokeColor = shapeStrokeColor;
	}

	public boolean isShapeStroke() {
		return shapeStroke;
	}

	public void setShapeStroke(boolean shapeStroke) {
		this.shapeStroke = shapeStroke;
	}

	public boolean isShapeFill() {
		return shapeFill;
	}

	public void setShapeFill(boolean shapeFill) {
		this.shapeFill = shapeFill;
	}

	public Color getShapeFillColor() {
		return shapeFillColor;
	}

	public void setShapeFillColor(Color shapeFillColor) {
		this.shapeFillColor = shapeFillColor;
	}

	public Point2D getStartMousePosition() {
		return startMousePosition;
	}

	public void setStartMousePosition(Point2D startMousePosition) {
		this.startMousePosition = startMousePosition;
	}

	public Point2D getCurrMousePosition() {
		return currMousePosition;
	}

	public void setCurrMousePosition(Point2D currMousePosition) {
		this.currMousePosition = currMousePosition;
	}

	public Point2D getPrevMousePosition() {
		return prevMousePosition;
	}

	public void setPrevMousePosition(Point2D prevMousePosition) {
		this.prevMousePosition = prevMousePosition;
	}

	public int getSelectedShape() {
		return selectedShape;
	}

	public void setSelectedShape(int selectedShape) {
		this.selectedShape = selectedShape;
	}

	public int getNPolygon() {
		return nPolygon;
	}

	public void setNPolygon(int nPolygon) {
		this.nPolygon = nPolygon;
	}

	public File getSaveFile() {
		return saveFile;
	}

	public void setSaveFile(File saveFile) {
		this.saveFile = saveFile;
	}

	public boolean isMouseInside() {
		return mouseInside;
	}

	public void setMouseInside(boolean mouseInside) {
		this.mouseInside = mouseInside;
	}
		
}
