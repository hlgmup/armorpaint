package arm.ui;

import zui.Zui;
import zui.Id;
import iron.object.MeshObject;
import arm.util.MeshUtil;

class TabMeshes {

	@:access(zui.Zui)
	public static function draw() {
		var ui = UISidebar.inst.ui;
		if (ui.tab(UISidebar.inst.htab2, tr("Meshes"))) {

			ui.beginSticky();
			ui.row([1 / 4, 1 / 4]);

			if (ui.button(tr("Import"))) {
				UIMenu.draw(function(ui: Zui) {
					ui.text(tr("Import"), Right, ui.t.HIGHLIGHT_COL);
					if (ui.button(tr("Replace Existing"), Left, '${Config.keymap.file_import_assets}')) {
						Project.importMesh(true);
					}
					if (ui.button(tr("Append"), Left)) {
						Project.importMesh(false);
					}
				}, 3);
			}
			if (ui.isHovered) ui.tooltip(tr("Import mesh file"));

			if (ui.button(tr("Tools..."))) {
				UIMenu.draw(function(ui: Zui) {
					ui.text(tr("Tools"), Right, ui.t.HIGHLIGHT_COL);
					if (ui.button(tr("Flip Normals"), Left)) {
						MeshUtil.flipNormals();
						Context.ddirty = 2;
					}
					if (ui.button(tr("Calculate Normals"), Left)) {
						MeshUtil.calcNormals();
						Context.ddirty = 2;
					}
					if (ui.button(tr("Geometry to Origin"), Left)) {
						MeshUtil.toOrigin();
						Context.ddirty = 2;
					}
					if (ui.button(tr("Apply Displacement"), Left)) {
						MeshUtil.applyDisplacement();
						MeshUtil.calcNormals();
						Context.ddirty = 2;
					}
					if (ui.button(tr("Rotate X"), Left)) {
						MeshUtil.swapAxis(1, 2);
						Context.ddirty = 2;
					}
					if (ui.button(tr("Rotate Y"), Left)) {
						MeshUtil.swapAxis(2, 0);
						Context.ddirty = 2;
					}
					if (ui.button(tr("Rotate Z"), Left)) {
						MeshUtil.swapAxis(0, 1);
						Context.ddirty = 2;
					}
				}, 8);
			}

			ui.endSticky();

			for (o in Project.paintObjects) {
				var h = Id.handle();
				h.selected = o.visible;
				o.visible = ui.check(h, o.name);
				if (ui.isHovered && ui.inputReleasedR) {
					UIMenu.draw(function(ui: Zui) {
						ui.text(o.name, Right, ui.t.HIGHLIGHT_COL);
						if (ui.button(tr("Export"), Left)) {
							BoxExport.showMesh();
						}
					}, 2);
				}
				if (h.changed) {
					var visibles: Array<MeshObject> = [];
					for (p in Project.paintObjects) if (p.visible) visibles.push(p);
					MeshUtil.mergeMesh(visibles);
					Context.ddirty = 2;
				}
			}
		}
	}
}
