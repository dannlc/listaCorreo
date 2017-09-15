package ar.edu.unq.iu.arena.xtend

import org.uqbar.arena.windows.SimpleWindow

import ar.edu.unq.iu.modelo.Pedido
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.bindings.NotNullObservable
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.Window
import ar.edu.unq.iu.appmodel.ListadoDePedidos

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class ListadoDePedidosAbiertosWindow extends SimpleWindow<ListadoDePedidos> {
	
	new(WindowOwner parent) {
		super(parent, new ListadoDePedidos)
		modelObject.pedidosAbiertos
		
	}
	
	override def createMainTemplate(Panel mainPanel) {
		title = "DominosPizza"
		taskDescription = "Pedidos abiertos"

		super.createMainTemplate(mainPanel)

		this.createResultsGrid(mainPanel)
		this.createGridActions(mainPanel)
	}
	
	def createGridActions(Panel panel) {
		
		val elementSelected = new NotNullObservable("pedidoSeleccionado")
		
		val actionsPanel = new Panel(panel).layout = new HorizontalLayout
		
		
		new Button(actionsPanel) => [
			caption = "Cancelar"
			onClick([|modelObject.cancelarPedido()])
			bindEnabled(elementSelected)
		]
		
		new Button(actionsPanel) => [
			caption = "Editar"
			onClick([|this.editarPedido()])
			bindEnabled(elementSelected)
		]

	}
	
	def editarPedido() {
		this.openDialog(new EditarPedidoWindow(this, null))//EL NULL DEBERIA SER EL PEDIDO SELECCIONADO
	}
	
	def openDialog(Dialog<?> dialog) {
		dialog.onAccept[|modelObject]// ??
		dialog.open
	}
	
	def createResultsGrid(Panel panel) {
		val table = new Table<Pedido>(panel, typeof(Pedido)) => [
			items <=> "pedidos"
			value <=> "pedidoSeleccionado"
			numberVisibleRows = 10
		]
		this.describeResultsGrid(table)
	}
	
	override protected addActions(Panel actionsPanel) {

		new Button(actionsPanel) => [
			caption = "Menu"
			onClick([|this.abrirMenu()])
		]

		new Button(actionsPanel) => [
			caption = "Pedidos Cerrados"
			onClick([|this.pedidosCerrados()])
		]
		
		new Button(actionsPanel) => [
			caption = "Salir"
			onClick([|this.close])
		]
		
		
	}
	
	def pedidosCerrados() {
		this.openWindow(new ListadoDePedidosCerrados(this))
	}
	
	def openWindow(Window<?> window) {
		//window.onAccept[|modelObject]// ??
		window.open
	}
	
	def abrirMenu() {
		this.openWindow(new MenuWindow(null, null))
	}
	
	override protected createFormPanel(Panel mainPanel) {
		val searchFormPanel = new Panel(mainPanel) => [
			layout = new ColumnLayout(4)
		]

	}
	
	def void describeResultsGrid(Table<Pedido> table) {
		new Column<Pedido>(table) => [
			title = "Pedido"
			fixedSize = 200
			bindContentsToProperty("id")
		]

		new Column<Pedido>(table) => [
			title = "Estado"
			fixedSize = 100
			alignRight
			bindContentsToProperty("estado")
		]

		new Column<Pedido>(table) => [
			title = "Monto"
			fixedSize = 200
			bindContentsToProperty("monto")
		]

		new Column<Pedido>(table) => [
			title = "Hora"
			fixedSize = 50
			bindContentsToProperty("fechaHora")
			
		]
	}
	
	
	
}