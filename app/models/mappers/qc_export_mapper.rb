module Mappers
  class QcExportMapper < BaseMapper
    def initialize params={}
      @dictionary = {
        "Không lỗi" => "No Error",
        "Mã vạch" => "Bar Code-Readability/Missing/Position",
        "Dơ, bẩn" => "Clean-Soil/Dirt/Grease",
        "Móp/nhăn, Hỏng bao bì" => "Damage-Crush / Dent / Crease / Tear",
        "Thủng" => "Damage-Puncture",
        "Màu in" => "Print-Colour",
        "Chữ in" => "Print-Text",
        "In tràn đường cắt" => "Print-Wrapper or Label or Sachet Film Cut/Orientation",
        "Thiếu bộ phận" => "Assembly-Missing",
        "Sai bộ phận" => "Assembly-Wrong",
        "Bụi" => "Clean-Dust",
        "Trầy xước" => "Damage-Scratches / Scuffing",
        "Lệch trọng lượng" => "Deviation-Weight",
        "Vị trí nhãn" => "Label / Sleeve /Wrapper -Position",
        "Mã sản xuất bị thiếu/không đọc được/vị trí" => "Production Code-missing / illegible / position",
        "Mở nắp" => "Opening Device - Loose Fit",
        "Cảm quan" => "Product Appearance",
        "Màu sắc/tách/lắng đọng sản phẩm" => "Product Colour / separation / sedimentation",
        "Vật lạ" => "Foreign Bodies",
        "Hư seal" => "Seal - Damage",
        "Vật sắc" => "Sharp Edges",
        "Nứt" => "Damage-Cracking",
        "Tách lớp" => "Delamination",
        "Chiều cao sản phẩm bên trong" => "Fill Height Variation",
        "Độ dính nhãn" => "Label / Sleeve-Adhesion",
        "Hư nắp" => "Opening Device - Pour Damaged",
        "Rách bộ phận mở hình chữ V" => "Opening Device - Tear Notch",
        "Thiết bị mở bị rách" => "Opening Device - Tear Strip",
        "Bám đá" => "Pack wet / Ice",
        "Thủng gói" => "Sachet String - Perforation",
        "Vị trí seal" => "Seal - Align",
        "Dư" => "Seal - Join",
        "Bung gói" => "Wrapper-Overwrapper-Integrity",
        "Keo dính" => "Adhesion-Glue",
        "Bong bóng khí" => "Air Pocket / Bubble",
        "Phồng" => "Blown / inflated Pack",
        "Hở seal" => "Crimp Seal / lid position",
        "Lệch seal" => "Flaps/Wrap-Skewing",
        "Rò rỉ" => "Internal Leakage",
        "Hư nhãn" => "Label / Sleeve-Damage",
        "Bám nắp" => "Lid Smearing",
        "Bung" => "Sleeve - Open",
        "Hư chốt" => "Tamper Proof",
        "Khoá" => "Trigger - Locking Device",
        "Lệch vòi" => "Trigger / Pump / Actuator - Alignment",
      }

      super
    end

    def apply_each checklist_item
      shop = checklist_item.checklist.try(:shop)
      user = checklist_item.checklist.try(:user)
      stock = checklist_item.stock
      common = [
        @locale.adjust_for_timezone(
          checklist_item.updated_at,
        ),
        shop.try(:store_type),
        shop.try(:city),
        shop.try(:npp),
        shop.try(:name),
        shop.try(:full_address),
        user.try(:name),
        stock.custom_attributes[:uc],
        stock.custom_attributes[:packaging],
        stock.try(:category),
        stock.custom_attributes[:group],
        stock.try(:name),
        stock.try(:sku),
      ]
      return [common + ['']*7] if checklist_item.data.empty?
      return checklist_item.data["records"].collect do |entry|
        common + [
          entry["HSD"].present? ? entry["HSD"] : entry["NSX"],
          entry["Số lô"],
          @dictionary[entry["Lỗi"]] || entry["Lỗi"],
          entry["Mức cảnh báo"] == "Xanh" ? 1 : 0,
          entry["Mức cảnh báo"] == "Vàng" ? 1 : 0,
          entry["Mức cảnh báo"] == "Đỏ" ? 1 : 0,
          #HACK, fix asap
          (entry["photo_uri"].try(:strip).try(:empty?) ? "" : "http://13.228.52.25#{entry["photo_uri"]}")
        ]
      end
    end
  end
end
