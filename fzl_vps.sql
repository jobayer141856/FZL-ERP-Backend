PGDMP       '            	    |            fzl_vps    16.3    16.3 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    304495    fzl_vps    DATABASE     �   CREATE DATABASE fzl_vps WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE fzl_vps;
                postgres    false                        2615    304496 
   commercial    SCHEMA        CREATE SCHEMA commercial;
    DROP SCHEMA commercial;
                postgres    false                        2615    304497    delivery    SCHEMA        CREATE SCHEMA delivery;
    DROP SCHEMA delivery;
                postgres    false                        2615    304498    drizzle    SCHEMA        CREATE SCHEMA drizzle;
    DROP SCHEMA drizzle;
                postgres    false                        2615    304499    hr    SCHEMA        CREATE SCHEMA hr;
    DROP SCHEMA hr;
                postgres    false            	            2615    304500    lab_dip    SCHEMA        CREATE SCHEMA lab_dip;
    DROP SCHEMA lab_dip;
                postgres    false            
            2615    304501    material    SCHEMA        CREATE SCHEMA material;
    DROP SCHEMA material;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    15                        2615    304502    purchase    SCHEMA        CREATE SCHEMA purchase;
    DROP SCHEMA purchase;
                postgres    false                        2615    304503    slider    SCHEMA        CREATE SCHEMA slider;
    DROP SCHEMA slider;
                postgres    false                        2615    304504    thread    SCHEMA        CREATE SCHEMA thread;
    DROP SCHEMA thread;
                postgres    false                        2615    304505    zipper    SCHEMA        CREATE SCHEMA zipper;
    DROP SCHEMA zipper;
                postgres    false                       1247    304507    batch_status    TYPE     m   CREATE TYPE zipper.batch_status AS ENUM (
    'pending',
    'completed',
    'rejected',
    'cancelled'
);
    DROP TYPE zipper.batch_status;
       zipper          postgres    false    14                       1247    304516    order_type_enum    TYPE     U   CREATE TYPE zipper.order_type_enum AS ENUM (
    'full',
    'slider',
    'tape'
);
 "   DROP TYPE zipper.order_type_enum;
       zipper          postgres    false    14                       1247    304524    print_in_enum    TYPE     `   CREATE TYPE zipper.print_in_enum AS ENUM (
    'portrait',
    'landscape',
    'break_down'
);
     DROP TYPE zipper.print_in_enum;
       zipper          postgres    false    14            !           1247    304532    slider_starting_section_enum    TYPE     �   CREATE TYPE zipper.slider_starting_section_enum AS ENUM (
    'die_casting',
    'slider_assembly',
    'coloring',
    '---'
);
 /   DROP TYPE zipper.slider_starting_section_enum;
       zipper          postgres    false    14            $           1247    304542    swatch_status_enum    TYPE     a   CREATE TYPE zipper.swatch_status_enum AS ENUM (
    'pending',
    'approved',
    'rejected'
);
 %   DROP TYPE zipper.swatch_status_enum;
       zipper          postgres    false    14            �           1255    304549 /   sfg_after_commercial_pi_entry_delete_function()    FUNCTION     r  CREATE FUNCTION commercial.sfg_after_commercial_pi_entry_delete_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE zipper.sfg SET
        pi = pi - OLD.pi_cash_quantity
    WHERE uuid = OLD.sfg_uuid;

    UPDATE thread.order_entry SET
        pi = pi - OLD.pi_cash_quantity
    WHERE uuid = OLD.thread_order_entry_uuid;

    RETURN OLD;
END;
$$;
 J   DROP FUNCTION commercial.sfg_after_commercial_pi_entry_delete_function();
    
   commercial          postgres    false    5            �           1255    304550 /   sfg_after_commercial_pi_entry_insert_function()    FUNCTION     r  CREATE FUNCTION commercial.sfg_after_commercial_pi_entry_insert_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE zipper.sfg SET
        pi = pi + NEW.pi_cash_quantity
    WHERE uuid = NEW.sfg_uuid;

    UPDATE thread.order_entry SET
        pi = pi + NEW.pi_cash_quantity
    WHERE uuid = NEW.thread_order_entry_uuid;

    RETURN NEW;
END;
$$;
 J   DROP FUNCTION commercial.sfg_after_commercial_pi_entry_insert_function();
    
   commercial          postgres    false    5            `           1255    304551 /   sfg_after_commercial_pi_entry_update_function()    FUNCTION     �  CREATE FUNCTION commercial.sfg_after_commercial_pi_entry_update_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE zipper.sfg SET
        pi = pi + NEW.pi_cash_quantity - OLD.pi_cash_quantity
    WHERE uuid = NEW.sfg_uuid;

    UPDATE thread.order_entry SET
        pi = pi + NEW.pi_cash_quantity - OLD.pi_cash_quantity
    WHERE uuid = NEW.thread_order_entry_uuid;

    RETURN NEW;
END;
$$;
 J   DROP FUNCTION commercial.sfg_after_commercial_pi_entry_update_function();
    
   commercial          postgres    false    5            �           1255    304552 2   packing_list_after_challan_entry_delete_function()    FUNCTION     +  CREATE FUNCTION delivery.packing_list_after_challan_entry_delete_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update delivery,packing_list
    UPDATE delivery.packing_list
    SET
        challan_uuid = NULL
    WHERE uuid = OLD.packing_list_uuid;
    RETURN OLD;
END;
$$;
 K   DROP FUNCTION delivery.packing_list_after_challan_entry_delete_function();
       delivery          postgres    false    6            R           1255    304553 2   packing_list_after_challan_entry_insert_function()    FUNCTION     7  CREATE FUNCTION delivery.packing_list_after_challan_entry_insert_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update delivery,packing_list
    UPDATE delivery.packing_list
    SET
        challan_uuid = NEW.challan_uuid
    WHERE uuid = NEW.packing_list_uuid;
    RETURN NEW;
END;
$$;
 K   DROP FUNCTION delivery.packing_list_after_challan_entry_insert_function();
       delivery          postgres    false    6            o           1255    304554 2   packing_list_after_challan_entry_update_function()    FUNCTION     7  CREATE FUNCTION delivery.packing_list_after_challan_entry_update_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update delivery,packing_list
    UPDATE delivery.packing_list
    SET
        challan_uuid = NEW.challan_uuid
    WHERE uuid = NEW.packing_list_uuid;
    RETURN NEW;
END;
$$;
 K   DROP FUNCTION delivery.packing_list_after_challan_entry_update_function();
       delivery          postgres    false    6            y           1255    304555 2   sfg_after_challan_receive_status_delete_function()    FUNCTION     �  CREATE FUNCTION delivery.sfg_after_challan_receive_status_delete_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update zipper,sfg
    UPDATE zipper.sfg
    SET
        warehouse = warehouse + CASE WHEN OLD.receive_status = 1 THEN pl_sfg.quantity ELSE 0 END,
        delivered = delivered - CASE WHEN OLD.receive_status = 1 THEN pl_sfg.quantity ELSE 0 END
    FROM (SELECT packing_list_entry.sfg_uuid, packing_list_entry.quantity FROM delivery.packing_list LEFT JOIN delivery.packing_list_entry ON packing_list.uuid = packing_list_entry.packing_list_uuid WHERE packing_list.challan_uuid = OLD.uuid) as pl_sfg
    WHERE uuid = pl_sfg.sfg_uuid;
    RETURN OLD;
END;
$$;
 K   DROP FUNCTION delivery.sfg_after_challan_receive_status_delete_function();
       delivery          postgres    false    6            L           1255    304556 2   sfg_after_challan_receive_status_insert_function()    FUNCTION     �  CREATE FUNCTION delivery.sfg_after_challan_receive_status_insert_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update zipper,sfg
    UPDATE zipper.sfg
    SET
        warehouse = warehouse - CASE WHEN NEW.receive_status = 1 THEN pl_sfg.quantity ELSE 0 END,
        delivered = delivered + CASE WHEN NEW.receive_status = 1 THEN pl_sfg.quantity ELSE 0 END
    FROM (SELECT packing_list_entry.sfg_uuid, packing_list_entry.quantity FROM delivery.packing_list LEFT JOIN delivery.packing_list_entry ON packing_list.uuid = packing_list_entry.packing_list_uuid WHERE packing_list.challan_uuid = NEW.uuid) as pl_sfg
    WHERE uuid = pl_sfg.sfg_uuid;
    RETURN NEW;
END;
$$;
 K   DROP FUNCTION delivery.sfg_after_challan_receive_status_insert_function();
       delivery          postgres    false    6            �           1255    304557 2   sfg_after_challan_receive_status_update_function()    FUNCTION     9  CREATE FUNCTION delivery.sfg_after_challan_receive_status_update_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update zipper,sfg
    UPDATE zipper.sfg
    SET
        warehouse = warehouse - CASE WHEN NEW.receive_status = 1 THEN pl_sfg.quantity ELSE 0 END + CASE WHEN OLD.receive_status = 1 THEN pl_sfg.quantity ELSE 0 END,
        delivered = delivered + CASE WHEN NEW.receive_status = 1 THEN pl_sfg.quantity ELSE 0 END - CASE WHEN OLD.receive_status = 1 THEN pl_sfg.quantity ELSE 0 END
    FROM (SELECT packing_list_entry.sfg_uuid, packing_list_entry.quantity FROM delivery.packing_list LEFT JOIN delivery.packing_list_entry ON packing_list.uuid = packing_list_entry.packing_list_uuid WHERE packing_list.challan_uuid = NEW.uuid) as pl_sfg
    WHERE uuid = pl_sfg.sfg_uuid;
    RETURN NEW;
END;
$$;
 K   DROP FUNCTION delivery.sfg_after_challan_receive_status_update_function();
       delivery          postgres    false    6            P           1255    304558 .   sfg_after_packing_list_entry_delete_function()    FUNCTION     Q  CREATE FUNCTION delivery.sfg_after_packing_list_entry_delete_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update zipper,sfg
    UPDATE zipper.sfg
    SET
        warehouse = warehouse - OLD.quantity,
        finishing_prod = finishing_prod + OLD.quantity
    WHERE uuid = OLD.sfg_uuid;
    RETURN OLD;
END;
$$;
 G   DROP FUNCTION delivery.sfg_after_packing_list_entry_delete_function();
       delivery          postgres    false    6            x           1255    304559 .   sfg_after_packing_list_entry_insert_function()    FUNCTION     Q  CREATE FUNCTION delivery.sfg_after_packing_list_entry_insert_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update zipper,sfg
    UPDATE zipper.sfg
    SET
        warehouse = warehouse + NEW.quantity,
        finishing_prod = finishing_prod - NEW.quantity
    WHERE uuid = NEW.sfg_uuid;
    RETURN NEW;
END;
$$;
 G   DROP FUNCTION delivery.sfg_after_packing_list_entry_insert_function();
       delivery          postgres    false    6            �           1255    304560 .   sfg_after_packing_list_entry_update_function()    FUNCTION     o  CREATE FUNCTION delivery.sfg_after_packing_list_entry_update_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update zipper,sfg
    UPDATE zipper.sfg
    SET
        warehouse = warehouse - OLD.quantity + NEW.quantity,
        finishing_prod = finishing_prod + OLD.quantity - NEW.quantity
    WHERE uuid = NEW.sfg_uuid;
    RETURN NEW;
END;
$$;
 G   DROP FUNCTION delivery.sfg_after_packing_list_entry_update_function();
       delivery          postgres    false    6            i           1255    304561 +   material_stock_after_material_info_delete()    FUNCTION     �   CREATE FUNCTION material.material_stock_after_material_info_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM material.stock
    WHERE material_uuid = OLD.uuid;
    RETURN OLD;
END;
$$;
 D   DROP FUNCTION material.material_stock_after_material_info_delete();
       material          postgres    false    10            I           1255    304562 +   material_stock_after_material_info_insert()    FUNCTION     �   CREATE FUNCTION material.material_stock_after_material_info_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO material.stock
       (uuid, material_uuid)
    VALUES
         (NEW.uuid, NEW.uuid);
    RETURN NEW;
END;
$$;
 D   DROP FUNCTION material.material_stock_after_material_info_insert();
       material          postgres    false    10            ]           1255    304563 *   material_stock_after_material_trx_delete()    FUNCTION     l  CREATE FUNCTION material.material_stock_after_material_trx_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE material.stock
    SET 
    stock = stock + OLD.trx_quantity,
    lab_dip = lab_dip - CASE WHEN OLD.trx_to = 'lab_dip' THEN OLD.trx_quantity ELSE 0 END,
    tape_making = tape_making - CASE WHEN OLD.trx_to = 'tape_making' THEN OLD.trx_quantity ELSE 0 END,
    coil_forming = coil_forming - CASE WHEN OLD.trx_to = 'coil_forming' THEN OLD.trx_quantity ELSE 0 END,
    dying_and_iron = dying_and_iron - CASE WHEN OLD.trx_to = 'dying_and_iron' THEN OLD.trx_quantity ELSE 0 END,
    m_gapping = m_gapping - CASE WHEN OLD.trx_to = 'm_gapping' THEN OLD.trx_quantity ELSE 0 END,
    v_gapping = v_gapping - CASE WHEN OLD.trx_to = 'v_gapping' THEN OLD.trx_quantity ELSE 0 END,
    v_teeth_molding = v_teeth_molding - CASE WHEN OLD.trx_to = 'v_teeth_molding' THEN OLD.trx_quantity ELSE 0 END,
    m_teeth_molding = m_teeth_molding - CASE WHEN OLD.trx_to = 'm_teeth_molding' THEN OLD.trx_quantity ELSE 0 END,
    teeth_assembling_and_polishing = teeth_assembling_and_polishing - CASE WHEN OLD.trx_to = 'teeth_assembling_and_polishing' THEN OLD.trx_quantity ELSE 0 END,
    m_teeth_cleaning = m_teeth_cleaning - CASE WHEN OLD.trx_to = 'm_teeth_cleaning' THEN OLD.trx_quantity ELSE 0 END,
    v_teeth_cleaning = v_teeth_cleaning - CASE WHEN OLD.trx_to = 'v_teeth_cleaning' THEN OLD.trx_quantity ELSE 0 END,
    plating_and_iron = plating_and_iron - CASE WHEN OLD.trx_to = 'plating_and_iron' THEN OLD.trx_quantity ELSE 0 END,
    m_sealing = m_sealing - CASE WHEN OLD.trx_to = 'm_sealing' THEN OLD.trx_quantity ELSE 0 END,
    v_sealing = v_sealing - CASE WHEN OLD.trx_to = 'v_sealing' THEN OLD.trx_quantity ELSE 0 END,
    n_t_cutting = n_t_cutting - CASE WHEN OLD.trx_to = 'n_t_cutting' THEN OLD.trx_quantity ELSE 0 END,
    v_t_cutting = v_t_cutting - CASE WHEN OLD.trx_to = 'v_t_cutting' THEN OLD.trx_quantity ELSE 0 END,
    m_stopper = m_stopper - CASE WHEN OLD.trx_to = 'm_stopper' THEN OLD.trx_quantity ELSE 0 END,
    v_stopper = v_stopper - CASE WHEN OLD.trx_to = 'v_stopper' THEN OLD.trx_quantity ELSE 0 END,
    n_stopper = n_stopper - CASE WHEN OLD.trx_to = 'n_stopper' THEN OLD.trx_quantity ELSE 0 END,
    cutting = cutting - CASE WHEN OLD.trx_to = 'cutting' THEN OLD.trx_quantity ELSE 0 END,
    m_qc_and_packing = m_qc_and_packing - CASE WHEN OLD.trx_to = 'm_qc_and_packing' THEN OLD.trx_quantity ELSE 0 END,
    v_qc_and_packing = v_qc_and_packing - CASE WHEN OLD.trx_to = 'v_qc_and_packing' THEN OLD.trx_quantity ELSE 0 END,
    n_qc_and_packing = n_qc_and_packing - CASE WHEN OLD.trx_to = 'n_qc_and_packing' THEN OLD.trx_quantity ELSE 0 END,
    s_qc_and_packing = s_qc_and_packing - CASE WHEN OLD.trx_to = 's_qc_and_packing' THEN OLD.trx_quantity ELSE 0 END,
    die_casting = die_casting - CASE WHEN OLD.trx_to = 'die_casting' THEN OLD.trx_quantity ELSE 0 END,
    slider_assembly = slider_assembly - CASE WHEN OLD.trx_to = 'slider_assembly' THEN OLD.trx_quantity ELSE 0 END,
    coloring = coloring - CASE WHEN OLD.trx_to = 'coloring' THEN OLD.trx_quantity ELSE 0 END

    WHERE material_uuid = OLD.material_uuid;
    RETURN OLD;
END;
$$;
 C   DROP FUNCTION material.material_stock_after_material_trx_delete();
       material          postgres    false    10            �           1255    304564 *   material_stock_after_material_trx_insert()    FUNCTION     l  CREATE FUNCTION material.material_stock_after_material_trx_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE material.stock
    SET 
    stock = stock -  NEW.trx_quantity,
    lab_dip = lab_dip + CASE WHEN NEW.trx_to = 'lab_dip' THEN NEW.trx_quantity ELSE 0 END,
    tape_making = tape_making + CASE WHEN NEW.trx_to = 'tape_making' THEN NEW.trx_quantity ELSE 0 END,
    coil_forming = coil_forming + CASE WHEN NEW.trx_to = 'coil_forming' THEN NEW.trx_quantity ELSE 0 END,
    dying_and_iron = dying_and_iron + CASE WHEN NEW.trx_to = 'dying_and_iron' THEN NEW.trx_quantity ELSE 0 END,
    m_gapping = m_gapping + CASE WHEN NEW.trx_to = 'm_gapping' THEN NEW.trx_quantity ELSE 0 END,
    v_gapping = v_gapping + CASE WHEN NEW.trx_to = 'v_gapping' THEN NEW.trx_quantity ELSE 0 END,
    v_teeth_molding = v_teeth_molding + CASE WHEN NEW.trx_to = 'v_teeth_molding' THEN NEW.trx_quantity ELSE 0 END,
    m_teeth_molding = m_teeth_molding + CASE WHEN NEW.trx_to = 'm_teeth_molding' THEN NEW.trx_quantity ELSE 0 END,
    teeth_assembling_and_polishing = teeth_assembling_and_polishing + CASE WHEN NEW.trx_to = 'teeth_assembling_and_polishing' THEN NEW.trx_quantity ELSE 0 END,
    m_teeth_cleaning = m_teeth_cleaning + CASE WHEN NEW.trx_to = 'm_teeth_cleaning' THEN NEW.trx_quantity ELSE 0 END,
    v_teeth_cleaning = v_teeth_cleaning + CASE WHEN NEW.trx_to = 'v_teeth_cleaning' THEN NEW.trx_quantity ELSE 0 END,
    plating_and_iron = plating_and_iron + CASE WHEN NEW.trx_to = 'plating_and_iron' THEN NEW.trx_quantity ELSE 0 END,
    m_sealing = m_sealing + CASE WHEN NEW.trx_to = 'm_sealing' THEN NEW.trx_quantity ELSE 0 END,
    v_sealing = v_sealing + CASE WHEN NEW.trx_to = 'v_sealing' THEN NEW.trx_quantity ELSE 0 END,
    n_t_cutting = n_t_cutting + CASE WHEN NEW.trx_to = 'n_t_cutting' THEN NEW.trx_quantity ELSE 0 END,
    v_t_cutting = v_t_cutting + CASE WHEN NEW.trx_to = 'v_t_cutting' THEN NEW.trx_quantity ELSE 0 END,
    m_stopper = m_stopper + CASE WHEN NEW.trx_to = 'm_stopper' THEN NEW.trx_quantity ELSE 0 END,
    v_stopper = v_stopper + CASE WHEN NEW.trx_to = 'v_stopper' THEN NEW.trx_quantity ELSE 0 END,
    n_stopper = n_stopper + CASE WHEN NEW.trx_to = 'n_stopper' THEN NEW.trx_quantity ELSE 0 END,
    cutting = cutting + CASE WHEN NEW.trx_to = 'cutting' THEN NEW.trx_quantity ELSE 0 END,
    m_qc_and_packing = m_qc_and_packing + CASE WHEN NEW.trx_to = 'm_qc_and_packing' THEN NEW.trx_quantity ELSE 0 END,
    v_qc_and_packing = v_qc_and_packing + CASE WHEN NEW.trx_to = 'v_qc_and_packing' THEN NEW.trx_quantity ELSE 0 END,
    n_qc_and_packing = n_qc_and_packing + CASE WHEN NEW.trx_to = 'n_qc_and_packing' THEN NEW.trx_quantity ELSE 0 END,
    s_qc_and_packing = s_qc_and_packing + CASE WHEN NEW.trx_to = 's_qc_and_packing' THEN NEW.trx_quantity ELSE 0 END,
    die_casting = die_casting + CASE WHEN NEW.trx_to = 'die_casting' THEN NEW.trx_quantity ELSE 0 END,
    slider_assembly = slider_assembly + CASE WHEN NEW.trx_to = 'slider_assembly' THEN NEW.trx_quantity ELSE 0 END,
    coloring = coloring + CASE WHEN NEW.trx_to = 'coloring' THEN NEW.trx_quantity ELSE 0 END
    WHERE material_uuid = NEW.material_uuid;
    RETURN NEW;
END;
$$;
 C   DROP FUNCTION material.material_stock_after_material_trx_insert();
       material          postgres    false    10            �           1255    304565 *   material_stock_after_material_trx_update()    FUNCTION     C  CREATE FUNCTION material.material_stock_after_material_trx_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE material.stock
    SET 
    stock = stock - NEW.trx_quantity + OLD.trx_quantity,
    lab_dip = lab_dip + CASE WHEN NEW.trx_to = 'lab_dip' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'lab_dip' THEN OLD.trx_quantity ELSE 0 END,
    tape_making = tape_making + CASE WHEN NEW.trx_to = 'tape_making' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'tape_making' THEN OLD.trx_quantity ELSE 0 END,
    coil_forming = coil_forming + CASE WHEN NEW.trx_to = 'coil_forming' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'coil_forming' THEN OLD.trx_quantity ELSE 0 END,
    dying_and_iron = dying_and_iron + CASE WHEN NEW.trx_to = 'dying_and_iron' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'dying_and_iron' THEN OLD.trx_quantity ELSE 0 END,
    m_gapping = m_gapping + CASE WHEN NEW.trx_to = 'm_gapping' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'm_gapping' THEN OLD.trx_quantity ELSE 0 END,
    v_gapping = v_gapping + CASE WHEN NEW.trx_to = 'v_gapping' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'v_gapping' THEN OLD.trx_quantity ELSE 0 END,
    v_teeth_molding = v_teeth_molding + CASE WHEN NEW.trx_to = 'v_teeth_molding' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'v_teeth_molding' THEN OLD.trx_quantity ELSE 0 END,
    m_teeth_molding = m_teeth_molding + CASE WHEN NEW.trx_to = 'm_teeth_molding' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'm_teeth_molding' THEN OLD.trx_quantity ELSE 0 END,
    teeth_assembling_and_polishing = teeth_assembling_and_polishing + CASE WHEN NEW.trx_to = 'teeth_assembling_and_polishing' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'teeth_assembling_and_polishing' THEN OLD.trx_quantity ELSE 0 END,
    m_teeth_cleaning = m_teeth_cleaning + CASE WHEN NEW.trx_to = 'm_teeth_cleaning' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'm_teeth_cleaning' THEN OLD.trx_quantity ELSE 0 END,
    v_teeth_cleaning = v_teeth_cleaning + CASE WHEN NEW.trx_to = 'v_teeth_cleaning' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'v_teeth_cleaning' THEN OLD.trx_quantity ELSE 0 END,
    plating_and_iron = plating_and_iron + CASE WHEN NEW.trx_to = 'plating_and_iron' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'plating_and_iron' THEN OLD.trx_quantity ELSE 0 END,
    m_sealing = m_sealing + CASE WHEN NEW.trx_to = 'm_sealing' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'm_sealing' THEN OLD.trx_quantity ELSE 0 END,
    v_sealing = v_sealing + CASE WHEN NEW.trx_to = 'v_sealing' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'v_sealing' THEN OLD.trx_quantity ELSE 0 END,
    n_t_cutting = n_t_cutting + CASE WHEN NEW.trx_to = 'n_t_cutting' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'n_t_cutting' THEN OLD.trx_quantity ELSE 0 END,
    v_t_cutting = v_t_cutting + CASE WHEN NEW.trx_to = 'v_t_cutting' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'v_t_cutting' THEN OLD.trx_quantity ELSE 0 END,
    m_stopper = m_stopper + CASE WHEN NEW.trx_to = 'm_stopper' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'm_stopper' THEN OLD.trx_quantity ELSE 0 END,
    v_stopper = v_stopper + CASE WHEN NEW.trx_to = 'v_stopper' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'v_stopper' THEN OLD.trx_quantity ELSE 0 END,
    n_stopper = n_stopper + CASE WHEN NEW.trx_to = 'n_stopper' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'n_stopper' THEN OLD.trx_quantity ELSE 0 END,
    cutting = cutting + CASE WHEN NEW.trx_to = 'cutting' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'cutting' THEN OLD.trx_quantity ELSE 0 END,
    m_qc_and_packing = m_qc_and_packing + CASE WHEN NEW.trx_to = 'm_qc_and_packing' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'm_qc_and_packing' THEN OLD.trx_quantity ELSE 0 END,
    v_qc_and_packing = v_qc_and_packing + CASE WHEN NEW.trx_to = 'v_qc_and_packing' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'v_qc_and_packing' THEN OLD.trx_quantity ELSE 0 END,
    n_qc_and_packing = n_qc_and_packing + CASE WHEN NEW.trx_to = 'n_qc_and_packing' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'n_qc_and_packing' THEN OLD.trx_quantity ELSE 0 END,
    s_qc_and_packing = s_qc_and_packing + CASE WHEN NEW.trx_to = 's_qc_and_packing' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 's_qc_and_packing' THEN OLD.trx_quantity ELSE 0 END,
    die_casting = die_casting + CASE WHEN NEW.trx_to = 'die_casting' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'die_casting' THEN OLD.trx_quantity ELSE 0 END,
    slider_assembly = slider_assembly + CASE WHEN NEW.trx_to = 'slider_assembly' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'slider_assembly' THEN OLD.trx_quantity ELSE 0 END,
    coloring = coloring + CASE WHEN NEW.trx_to = 'coloring' THEN NEW.trx_quantity ELSE 0 END - CASE WHEN OLD.trx_to = 'coloring' THEN OLD.trx_quantity ELSE 0 END
    WHERE material_uuid = NEW.material_uuid;
    RETURN NEW;
END;
$$;
 C   DROP FUNCTION material.material_stock_after_material_trx_update();
       material          postgres    false    10            e           1255    304566 +   material_stock_after_material_used_delete()    FUNCTION     �  CREATE FUNCTION material.material_stock_after_material_used_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE material.stock
    SET 
    lab_dip = lab_dip + CASE WHEN OLD.section = 'lab_dip' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    tape_making = tape_making + CASE WHEN OLD.section = 'tape_making' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    coil_forming = coil_forming + CASE WHEN OLD.section = 'coil_forming' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    dying_and_iron = dying_and_iron + CASE WHEN OLD.section = 'dying_and_iron' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_gapping = m_gapping + CASE WHEN OLD.section = 'm_gapping' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_gapping = v_gapping + CASE WHEN OLD.section = 'v_gapping' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_teeth_molding = v_teeth_molding + CASE WHEN OLD.section = 'v_teeth_molding' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_teeth_molding = m_teeth_molding + CASE WHEN OLD.section = 'm_teeth_molding' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    teeth_assembling_and_polishing = teeth_assembling_and_polishing + CASE WHEN OLD.section = 'teeth_assembling_and_polishing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_teeth_cleaning = m_teeth_cleaning + CASE WHEN OLD.section = 'm_teeth_cleaning' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_teeth_cleaning = v_teeth_cleaning + CASE WHEN OLD.section = 'v_teeth_cleaning' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    plating_and_iron = plating_and_iron + CASE WHEN OLD.section = 'plating_and_iron' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_sealing = m_sealing + CASE WHEN OLD.section = 'm_sealing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_sealing = v_sealing + CASE WHEN OLD.section = 'v_sealing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    n_t_cutting = n_t_cutting + CASE WHEN OLD.section = 'n_t_cutting' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_t_cutting = v_t_cutting + CASE WHEN OLD.section = 'v_t_cutting' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_stopper = m_stopper + CASE WHEN OLD.section = 'm_stopper' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_stopper = v_stopper + CASE WHEN OLD.section = 'v_stopper' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    n_stopper = n_stopper + CASE WHEN OLD.section = 'n_stopper' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    cutting = cutting + CASE WHEN OLD.section = 'cutting' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_qc_and_packing = m_qc_and_packing + CASE WHEN OLD.section = 'm_qc_and_packing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_qc_and_packing = v_qc_and_packing + CASE WHEN OLD.section = 'v_qc_and_packing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    n_qc_and_packing = n_qc_and_packing + CASE WHEN OLD.section = 'n_qc_and_packing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    s_qc_and_packing = s_qc_and_packing + CASE WHEN OLD.section = 's_qc_and_packing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    die_casting = die_casting + CASE WHEN OLD.section = 'die_casting' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    slider_assembly = slider_assembly + CASE WHEN OLD.section = 'slider_assembly' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    coloring = coloring + CASE WHEN OLD.section = 'coloring' THEN OLD.used_quantity + OLD.wastage ELSE 0 END
    WHERE material_uuid = OLD.material_uuid;
    RETURN OLD;
END;
$$;
 D   DROP FUNCTION material.material_stock_after_material_used_delete();
       material          postgres    false    10            �           1255    304567 +   material_stock_after_material_used_insert()    FUNCTION     �  CREATE FUNCTION material.material_stock_after_material_used_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE material.stock
    SET 
    lab_dip = lab_dip - CASE WHEN NEW.section = 'lab_dip' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    tape_making = tape_making - CASE WHEN NEW.section = 'tape_making' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    coil_forming = coil_forming - CASE WHEN NEW.section = 'coil_forming' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    dying_and_iron = dying_and_iron - CASE WHEN NEW.section = 'dying_and_iron' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_gapping = m_gapping - CASE WHEN NEW.section = 'm_gapping' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_gapping = v_gapping - CASE WHEN NEW.section = 'v_gapping' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_teeth_molding = v_teeth_molding - CASE WHEN NEW.section = 'v_teeth_molding' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_teeth_molding = m_teeth_molding - CASE WHEN NEW.section = 'm_teeth_molding' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    teeth_assembling_and_polishing = teeth_assembling_and_polishing - CASE WHEN NEW.section = 'teeth_assembling_and_polishing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_teeth_cleaning = m_teeth_cleaning - CASE WHEN NEW.section = 'm_teeth_cleaning' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_teeth_cleaning = v_teeth_cleaning - CASE WHEN NEW.section = 'v_teeth_cleaning' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    plating_and_iron = plating_and_iron - CASE WHEN NEW.section = 'plating_and_iron' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_sealing = m_sealing - CASE WHEN NEW.section = 'm_sealing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_sealing = v_sealing - CASE WHEN NEW.section = 'v_sealing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    n_t_cutting = n_t_cutting - CASE WHEN NEW.section = 'n_t_cutting' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_t_cutting = v_t_cutting - CASE WHEN NEW.section = 'v_t_cutting' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_stopper = m_stopper - CASE WHEN NEW.section = 'm_stopper' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_stopper = v_stopper - CASE WHEN NEW.section = 'v_stopper' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    n_stopper = n_stopper - CASE WHEN NEW.section = 'n_stopper' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    cutting = cutting - CASE WHEN NEW.section = 'cutting' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_qc_and_packing = m_qc_and_packing - CASE WHEN NEW.section = 'm_qc_and_packing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_qc_and_packing = v_qc_and_packing - CASE WHEN NEW.section = 'v_qc_and_packing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    n_qc_and_packing = n_qc_and_packing - CASE WHEN NEW.section = 'n_qc_and_packing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    s_qc_and_packing = s_qc_and_packing - CASE WHEN NEW.section = 's_qc_and_packing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    die_casting = die_casting - CASE WHEN NEW.section = 'die_casting' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    slider_assembly = slider_assembly - CASE WHEN NEW.section = 'slider_assembly' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    coloring = coloring - CASE WHEN NEW.section = 'coloring' THEN NEW.used_quantity + NEW.wastage ELSE 0 END
   
    WHERE material_uuid = NEW.material_uuid;
    RETURN NEW;
END;
$$;
 D   DROP FUNCTION material.material_stock_after_material_used_insert();
       material          postgres    false    10            �           1255    304568 +   material_stock_after_material_used_update()    FUNCTION     L  CREATE FUNCTION material.material_stock_after_material_used_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE material.stock
    SET 
    lab_dip = lab_dip + 
    CASE WHEN NEW.section = 'lab_dip' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    tape_making = tape_making + 
    CASE WHEN OLD.section = 'tape_making' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    coil_forming = coil_forming + 
    CASE WHEN OLD.section = 'coil_forming' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    dying_and_iron = dying_and_iron + 
    CASE WHEN OLD.section = 'dying_and_iron' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_gapping = m_gapping + 
    CASE WHEN OLD.section = 'm_gapping' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_gapping = v_gapping + 
    CASE WHEN OLD.section = 'v_gapping' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_teeth_molding = v_teeth_molding + 
    CASE WHEN OLD.section = 'v_teeth_molding' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_teeth_molding = m_teeth_molding + 
    CASE WHEN OLD.section = 'm_teeth_molding' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    teeth_assembling_and_polishing = teeth_assembling_and_polishing + 
    CASE WHEN OLD.section = 'teeth_assembling_and_polishing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_teeth_cleaning = m_teeth_cleaning + 
    CASE WHEN OLD.section = 'm_teeth_cleaning' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_teeth_cleaning = v_teeth_cleaning + 
    CASE WHEN OLD.section = 'v_teeth_cleaning' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    plating_and_iron = plating_and_iron + 
    CASE WHEN OLD.section = 'plating_and_iron' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_sealing = m_sealing + 
    CASE WHEN OLD.section = 'm_sealing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_sealing = v_sealing + 
    CASE WHEN OLD.section = 'v_sealing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    n_t_cutting = n_t_cutting + 
    CASE WHEN OLD.section = 'n_t_cutting' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_t_cutting = v_t_cutting + 
    CASE WHEN OLD.section = 'v_t_cutting' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_stopper = m_stopper + 
    CASE WHEN OLD.section = 'm_stopper' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_stopper = v_stopper + 
    CASE WHEN OLD.section = 'v_stopper' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    n_stopper = n_stopper + 
    CASE WHEN OLD.section = 'n_stopper' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    cutting = cutting + 
    CASE WHEN OLD.section = 'cutting' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    m_qc_and_packing = m_qc_and_packing + 
    CASE WHEN OLD.section = 'm_qc_and_packing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    v_qc_and_packing = v_qc_and_packing + 
    CASE WHEN OLD.section = 'v_qc_and_packing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    n_qc_and_packing = n_qc_and_packing + 
    CASE WHEN OLD.section = 'n_qc_and_packing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    s_qc_and_packing = s_qc_and_packing + 
    CASE WHEN OLD.section = 's_qc_and_packing' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    die_casting = die_casting + 
    CASE WHEN OLD.section = 'die_casting' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    slider_assembly = slider_assembly + 
    CASE WHEN OLD.section = 'slider_assembly' THEN OLD.used_quantity + OLD.wastage ELSE 0 END,
    coloring = coloring + 
    CASE WHEN OLD.section = 'coloring' THEN OLD.used_quantity + OLD.wastage ELSE 0 END
    WHERE material_uuid = NEW.material_uuid;

    UPDATE material.stock
    SET
    lab_dip = lab_dip -
    CASE WHEN NEW.section = 'lab_dip' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    tape_making = tape_making -
    CASE WHEN NEW.section = 'tape_making' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    coil_forming = coil_forming -
    CASE WHEN NEW.section = 'coil_forming' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    dying_and_iron = dying_and_iron -
    CASE WHEN NEW.section = 'dying_and_iron' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_gapping = m_gapping -
    CASE WHEN NEW.section = 'm_gapping' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_gapping = v_gapping -
    CASE WHEN NEW.section = 'v_gapping' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_teeth_molding = v_teeth_molding -
    CASE WHEN NEW.section = 'v_teeth_molding' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_teeth_molding = m_teeth_molding -
    CASE WHEN NEW.section = 'm_teeth_molding' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    teeth_assembling_and_polishing = teeth_assembling_and_polishing -
    CASE WHEN NEW.section = 'teeth_assembling_and_polishing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_teeth_cleaning = m_teeth_cleaning -
    CASE WHEN NEW.section = 'm_teeth_cleaning' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_teeth_cleaning = v_teeth_cleaning -
    CASE WHEN NEW.section = 'v_teeth_cleaning' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    plating_and_iron = plating_and_iron -
    CASE WHEN NEW.section = 'plating_and_iron' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_sealing = m_sealing -
    CASE WHEN NEW.section = 'm_sealing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_sealing = v_sealing -
    CASE WHEN NEW.section = 'v_sealing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    n_t_cutting = n_t_cutting -
    CASE WHEN NEW.section = 'n_t_cutting' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_t_cutting = v_t_cutting -
    CASE WHEN NEW.section = 'v_t_cutting' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_stopper = m_stopper -
    CASE WHEN NEW.section = 'm_stopper' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_stopper = v_stopper -
    CASE WHEN NEW.section = 'v_stopper' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    n_stopper = n_stopper -
    CASE WHEN NEW.section = 'n_stopper' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    cutting = cutting -
    CASE WHEN NEW.section = 'cutting' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    m_qc_and_packing = m_qc_and_packing -
    CASE WHEN NEW.section = 'm_qc_and_packing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    v_qc_and_packing = v_qc_and_packing -
    CASE WHEN NEW.section = 'v_qc_and_packing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    n_qc_and_packing = n_qc_and_packing -
    CASE WHEN NEW.section = 'n_qc_and_packing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    s_qc_and_packing = s_qc_and_packing -
    CASE WHEN NEW.section = 's_qc_and_packing' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    die_casting = die_casting -
    CASE WHEN NEW.section = 'die_casting' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    slider_assembly = slider_assembly -
    CASE WHEN NEW.section = 'slider_assembly' THEN NEW.used_quantity + NEW.wastage ELSE 0 END,
    coloring = coloring -
    CASE WHEN NEW.section = 'coloring' THEN NEW.used_quantity + NEW.wastage ELSE 0 END
    WHERE material_uuid = NEW.material_uuid;
    RETURN NEW;
END;
$$;
 D   DROP FUNCTION material.material_stock_after_material_used_update();
       material          postgres    false    10            �           1255    304569 ,   material_stock_after_purchase_entry_delete()    FUNCTION       CREATE FUNCTION material.material_stock_after_purchase_entry_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE material.stock
        SET 
            stock = stock - OLD.quantity
    WHERE material_uuid = OLD.material_uuid;
    RETURN OLD;
END;

$$;
 E   DROP FUNCTION material.material_stock_after_purchase_entry_delete();
       material          postgres    false    10            T           1255    304570 ,   material_stock_after_purchase_entry_insert()    FUNCTION       CREATE FUNCTION material.material_stock_after_purchase_entry_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE material.stock
        SET 
            stock = stock + NEW.quantity
    WHERE material_uuid = NEW.material_uuid;
    RETURN NEW;
END;
$$;
 E   DROP FUNCTION material.material_stock_after_purchase_entry_insert();
       material          postgres    false    10            �           1255    304571 ,   material_stock_after_purchase_entry_update()    FUNCTION       CREATE FUNCTION material.material_stock_after_purchase_entry_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
    IF NEW.material_uuid <> OLD.material_uuid THEN
        -- Deduct the old quantity from the old item's stock
        UPDATE material.stock
        SET stock = stock - OLD.quantity
        WHERE material_uuid = OLD.material_uuid;

        -- Add the new quantity to the new item's stock
        UPDATE material.stock
        SET stock = stock + NEW.quantity
        WHERE material_uuid = NEW.material_uuid;
    ELSE
        -- If the item has not changed, update the stock with the difference
        UPDATE material.stock
        SET stock = stock + NEW.quantity - OLD.quantity
        WHERE material_uuid = NEW.material_uuid;
    END IF;
    RETURN NEW;
END;

$$;
 E   DROP FUNCTION material.material_stock_after_purchase_entry_update();
       material          postgres    false    10            �           1255    304572 .   material_stock_sfg_after_stock_to_sfg_delete()    FUNCTION     4  CREATE FUNCTION material.material_stock_sfg_after_stock_to_sfg_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    --Update material.stock table
    UPDATE material.stock 
    SET
        stock = stock + OLD.trx_quantity
    WHERE stock.material_uuid = OLD.material_uuid;

    --Update zipper.sfg table
    UPDATE zipper.sfg
    SET
        dying_and_iron_prod = dying_and_iron_prod 
            - CASE WHEN OLD.trx_to = 'dying_and_iron_prod' THEN OLD.trx_quantity ELSE 0 END,
        teeth_molding_stock = teeth_molding_stock 
            - CASE WHEN OLD.trx_to = 'teeth_molding_stock' THEN OLD.trx_quantity ELSE 0 END,
        teeth_molding_prod = teeth_molding_prod 
            - CASE WHEN OLD.trx_to = 'teeth_molding_prod' THEN OLD.trx_quantity ELSE 0 END,
        teeth_coloring_stock = teeth_coloring_stock
            - CASE WHEN OLD.trx_to = 'teeth_coloring_stock' THEN OLD.trx_quantity ELSE 0 END,
        teeth_coloring_prod = teeth_coloring_prod
            - CASE WHEN OLD.trx_to = 'teeth_coloring_prod' THEN OLD.trx_quantity ELSE 0 END,
        finishing_stock = finishing_stock
            - CASE WHEN OLD.trx_to = 'finishing_stock' THEN OLD.trx_quantity ELSE 0 END,
        finishing_prod = finishing_prod
            - CASE WHEN OLD.trx_to = 'finishing_prod' THEN OLD.trx_quantity ELSE 0 END,
        coloring_prod = coloring_prod
            - CASE WHEN OLD.trx_to = 'coloring_prod' THEN OLD.trx_quantity ELSE 0 END,
        warehouse = warehouse
            - CASE WHEN OLD.trx_to = 'warehouse' THEN OLD.trx_quantity ELSE 0 END,
        delivered = delivered
            - CASE WHEN OLD.trx_to = 'delivered' THEN OLD.trx_quantity ELSE 0 END,
        pi = pi 
            - CASE WHEN OLD.trx_to = 'pi' THEN OLD.trx_quantity ELSE 0 END
    WHERE order_entry_uuid = OLD.order_entry_uuid;

    RETURN OLD;
END;
$$;
 G   DROP FUNCTION material.material_stock_sfg_after_stock_to_sfg_delete();
       material          postgres    false    10            ~           1255    304573 .   material_stock_sfg_after_stock_to_sfg_insert()    FUNCTION     =  CREATE FUNCTION material.material_stock_sfg_after_stock_to_sfg_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    --Update material.stock table
    UPDATE material.stock 
    SET
        stock = stock - NEW.trx_quantity
    WHERE stock.material_uuid = NEW.material_uuid;

    --Update zipper.sfg table
    UPDATE zipper.sfg
    SET
        dying_and_iron_prod = dying_and_iron_prod 
            + CASE WHEN NEW.trx_to = 'dying_and_iron_prod' THEN NEW.trx_quantity ELSE 0 END,
        teeth_molding_stock = teeth_molding_stock 
            + CASE WHEN NEW.trx_to = 'teeth_molding_stock' THEN NEW.trx_quantity ELSE 0 END,
        teeth_molding_prod = teeth_molding_prod 
            + CASE WHEN NEW.trx_to = 'teeth_molding_prod' THEN NEW.trx_quantity ELSE 0 END,
        teeth_coloring_stock = teeth_coloring_stock
            + CASE WHEN NEW.trx_to = 'teeth_coloring_stock' THEN NEW.trx_quantity ELSE 0 END,
        teeth_coloring_prod = teeth_coloring_prod
            + CASE WHEN NEW.trx_to = 'teeth_coloring_prod' THEN NEW.trx_quantity ELSE 0 END,
        finishing_stock = finishing_stock
            + CASE WHEN NEW.trx_to = 'finishing_stock' THEN NEW.trx_quantity ELSE 0 END,
        finishing_prod = finishing_prod
            + CASE WHEN NEW.trx_to = 'finishing_prod' THEN NEW.trx_quantity ELSE 0 END,
        coloring_prod = coloring_prod
            + CASE WHEN NEW.trx_to = 'coloring_prod' THEN NEW.trx_quantity ELSE 0 END,
        warehouse = warehouse
            + CASE WHEN NEW.trx_to = 'warehouse' THEN NEW.trx_quantity ELSE 0 END,
        delivered = delivered
            + CASE WHEN NEW.trx_to = 'delivered' THEN NEW.trx_quantity ELSE 0 END,
        pi = pi 
            + CASE WHEN NEW.trx_to = 'pi' THEN NEW.trx_quantity ELSE 0 END
        
    WHERE order_entry_uuid = NEW.order_entry_uuid;
    RETURN NEW;

END;
$$;
 G   DROP FUNCTION material.material_stock_sfg_after_stock_to_sfg_insert();
       material          postgres    false    10            �           1255    304574 .   material_stock_sfg_after_stock_to_sfg_update()    FUNCTION       CREATE FUNCTION material.material_stock_sfg_after_stock_to_sfg_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    --Update material.stock table
    UPDATE material.stock 
    SET
        stock = stock - NEW.trx_quantity + OLD.trx_quantity
    WHERE stock.material_uuid = NEW.material_uuid;

    --Update zipper.sfg table
    UPDATE zipper.sfg
    SET
        dying_and_iron_prod = dying_and_iron_prod 
            + CASE WHEN NEW.trx_to = 'dying_and_iron_prod' THEN NEW.trx_quantity ELSE 0 END
            - CASE WHEN OLD.trx_to = 'dying_and_iron_prod' THEN OLD.trx_quantity ELSE 0 END,
        teeth_molding_stock = teeth_molding_stock 
            + CASE WHEN NEW.trx_to = 'teeth_molding_stock' THEN NEW.trx_quantity ELSE 0 END
            - CASE WHEN OLD.trx_to = 'teeth_molding_stock' THEN OLD.trx_quantity ELSE 0 END,
        teeth_molding_prod = teeth_molding_prod 
            + CASE WHEN NEW.trx_to = 'teeth_molding_prod' THEN NEW.trx_quantity ELSE 0 END
            - CASE WHEN OLD.trx_to = 'teeth_molding_prod' THEN OLD.trx_quantity ELSE 0 END,
        teeth_coloring_stock = teeth_coloring_stock
            + CASE WHEN NEW.trx_to = 'teeth_coloring_stock' THEN NEW.trx_quantity ELSE 0 END
            - CASE WHEN OLD.trx_to = 'teeth_coloring_stock' THEN OLD.trx_quantity ELSE 0 END,
        teeth_coloring_prod = teeth_coloring_prod
            + CASE WHEN NEW.trx_to = 'teeth_coloring_prod' THEN NEW.trx_quantity ELSE 0 END
            - CASE WHEN OLD.trx_to = 'teeth_coloring_prod' THEN OLD.trx_quantity ELSE 0 END,
        finishing_stock = finishing_stock
            + CASE WHEN NEW.trx_to = 'finishing_stock' THEN NEW.trx_quantity ELSE 0 END
            - CASE WHEN OLD.trx_to = 'finishing_stock' THEN OLD.trx_quantity ELSE 0 END,
        finishing_prod = finishing_prod
            + CASE WHEN NEW.trx_to = 'finishing_prod' THEN NEW.trx_quantity ELSE 0 END
            - CASE WHEN OLD.trx_to = 'finishing_prod' THEN OLD.trx_quantity ELSE 0 END,
        coloring_prod = coloring_prod
            + CASE WHEN NEW.trx_to = 'coloring_prod' THEN NEW.trx_quantity ELSE 0 END
            - CASE WHEN OLD.trx_to = 'coloring_prod' THEN OLD.trx_quantity ELSE 0 END,
        warehouse = warehouse
            + CASE WHEN NEW.trx_to = 'warehouse' THEN NEW.trx_quantity ELSE 0 END
            - CASE WHEN OLD.trx_to = 'warehouse' THEN OLD.trx_quantity ELSE 0 END,
        delivered = delivered
            + CASE WHEN NEW.trx_to = 'delivered' THEN NEW.trx_quantity ELSE 0 END
            - CASE WHEN OLD.trx_to = 'delivered' THEN OLD.trx_quantity ELSE 0 END,
        pi = pi
            + CASE WHEN NEW.trx_to = 'pi' THEN NEW.trx_quantity ELSE 0 END
            - CASE WHEN OLD.trx_to = 'pi' THEN OLD.trx_quantity ELSE 0 END
    WHERE order_entry_uuid = NEW.order_entry_uuid;

    RETURN NEW;

END;
$$;
 G   DROP FUNCTION material.material_stock_sfg_after_stock_to_sfg_update();
       material          postgres    false    10            m           1255    304575 >   thread_batch_entry_after_batch_entry_production_delete_funct()    FUNCTION     �  CREATE FUNCTION public.thread_batch_entry_after_batch_entry_production_delete_funct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE thread.batch_entry
    SET
        coning_production_quantity = coning_production_quantity - OLD.production_quantity,
        coning_carton_quantity = coning_carton_quantity - OLD.coning_carton_quantity
    WHERE uuid = OLD.batch_entry_uuid;

    UPDATE thread.order_entry
    SET
        production_quantity = production_quantity - OLD.production_quantity
        -- production_quantity_in_kg = production_quantity_in_kg - OLD.production_quantity_in_kg

    WHERE uuid = (SELECT order_entry_uuid FROM thread.batch_entry WHERE uuid = OLD.batch_entry_uuid);

    RETURN OLD;
END;

$$;
 U   DROP FUNCTION public.thread_batch_entry_after_batch_entry_production_delete_funct();
       public          postgres    false    15            c           1255    304576 >   thread_batch_entry_after_batch_entry_production_insert_funct()    FUNCTION     �  CREATE FUNCTION public.thread_batch_entry_after_batch_entry_production_insert_funct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
    UPDATE thread.batch_entry
    SET
        coning_production_quantity = coning_production_quantity + NEW.production_quantity,
        coning_carton_quantity = coning_carton_quantity + NEW.coning_carton_quantity
    WHERE uuid = NEW.batch_entry_uuid;

    UPDATE thread.order_entry
    SET
        production_quantity = production_quantity + NEW.production_quantity
        -- production_quantity_in_kg = production_quantity_in_kg + NEW.production_quantity_in_kg

    WHERE uuid = (SELECT order_entry_uuid FROM thread.batch_entry WHERE uuid = NEW.batch_entry_uuid);

    RETURN NEW;
END;

$$;
 U   DROP FUNCTION public.thread_batch_entry_after_batch_entry_production_insert_funct();
       public          postgres    false    15            �           1255    304577 >   thread_batch_entry_after_batch_entry_production_update_funct()    FUNCTION     P  CREATE FUNCTION public.thread_batch_entry_after_batch_entry_production_update_funct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
    UPDATE thread.batch_entry
    SET
        coning_production_quantity = coning_production_quantity - OLD.production_quantity + NEW.production_quantity,
        coning_carton_quantity = coning_carton_quantity - OLD.coning_carton_quantity + NEW.coning_carton_quantity
    WHERE uuid = NEW.batch_entry_uuid;

    UPDATE thread.order_entry
    SET
        production_quantity = production_quantity - OLD.production_quantity + NEW.production_quantity
        -- production_quantity_in_kg = production_quantity_in_kg - OLD.production_quantity_in_kg + NEW.production_quantity_in_kg

    WHERE uuid = (SELECT order_entry_uuid FROM thread.batch_entry WHERE uuid = NEW.batch_entry_uuid);

    RETURN NEW;
END;

$$;
 U   DROP FUNCTION public.thread_batch_entry_after_batch_entry_production_update_funct();
       public          postgres    false    15            Y           1255    304578 A   thread_batch_entry_and_order_entry_after_batch_entry_trx_delete()    FUNCTION        CREATE FUNCTION public.thread_batch_entry_and_order_entry_after_batch_entry_trx_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
    UPDATE thread.batch_entry
    SET
        transfer_quantity = transfer_quantity - OLD.quantity,
        coning_production_quantity = coning_production_quantity + OLD.quantity,
        transfer_carton_quantity = transfer_carton_quantity - OLD.carton_quantity,
        coning_carton_quantity = coning_carton_quantity + OLD.carton_quantity
    WHERE uuid = OLD.batch_entry_uuid;

    UPDATE thread.order_entry
    SET
        warehouse = warehouse - OLD.quantity,
        carton_quantity = carton_quantity - OLD.carton_quantity
    WHERE uuid = (SELECT order_entry_uuid FROM thread.batch_entry WHERE uuid = OLD.batch_entry_uuid);
    RETURN OLD;
END;

$$;
 X   DROP FUNCTION public.thread_batch_entry_and_order_entry_after_batch_entry_trx_delete();
       public          postgres    false    15            �           1255    304579 @   thread_batch_entry_and_order_entry_after_batch_entry_trx_funct()    FUNCTION       CREATE FUNCTION public.thread_batch_entry_and_order_entry_after_batch_entry_trx_funct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
    UPDATE thread.batch_entry
    SET
        transfer_quantity = transfer_quantity + NEW.quantity,
        coning_production_quantity = coning_production_quantity - NEW.quantity,
        transfer_carton_quantity = transfer_carton_quantity + NEW.carton_quantity,
        coning_carton_quantity = coning_carton_quantity - NEW.carton_quantity
    WHERE uuid = NEW.batch_entry_uuid;

    UPDATE thread.order_entry
    SET
        warehouse = warehouse + NEW.quantity,
        carton_quantity = carton_quantity + NEW.carton_quantity
    WHERE uuid = (SELECT order_entry_uuid FROM thread.batch_entry WHERE uuid = NEW.batch_entry_uuid);
    RETURN NEW;
END;

$$;
 W   DROP FUNCTION public.thread_batch_entry_and_order_entry_after_batch_entry_trx_funct();
       public          postgres    false    15            q           1255    304580 A   thread_batch_entry_and_order_entry_after_batch_entry_trx_update()    FUNCTION     �  CREATE FUNCTION public.thread_batch_entry_and_order_entry_after_batch_entry_trx_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE thread.batch_entry
    SET
        transfer_quantity = transfer_quantity - OLD.quantity + NEW.quantity,
        coning_production_quantity = coning_production_quantity + OLD.quantity - NEW.quantity,
        transfer_carton_quantity = transfer_carton_quantity - OLD.carton_quantity + NEW.carton_quantity,
        coning_carton_quantity = coning_carton_quantity + OLD.carton_quantity - NEW.carton_quantity
    WHERE uuid = NEW.batch_entry_uuid;

    UPDATE thread.order_entry
    SET
        warehouse = warehouse - OLD.quantity + NEW.quantity,
        carton_quantity = carton_quantity - OLD.carton_quantity + NEW.carton_quantity
    WHERE uuid = (SELECT order_entry_uuid FROM thread.batch_entry WHERE uuid = NEW.batch_entry_uuid);
    RETURN NEW;
END;

$$;
 X   DROP FUNCTION public.thread_batch_entry_and_order_entry_after_batch_entry_trx_update();
       public          postgres    false    15            �           1255    304581 -   thread_order_entry_after_batch_entry_delete()    FUNCTION     ;  CREATE FUNCTION public.thread_order_entry_after_batch_entry_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE thread.order_entry
        SET
            production_quantity = production_quantity - OLD.coning_production_quantity
        WHERE
            uuid = OLD.order_entry_uuid;
    END;
$$;
 D   DROP FUNCTION public.thread_order_entry_after_batch_entry_delete();
       public          postgres    false    15            �           1255    304582 -   thread_order_entry_after_batch_entry_insert()    FUNCTION     B  CREATE FUNCTION public.thread_order_entry_after_batch_entry_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE thread.order_entry
      
        SET
            production_quantity = production_quantity + NEW.coning_production_quantity
        WHERE
            uuid = NEW.order_entry_uuid;
    END;
$$;
 D   DROP FUNCTION public.thread_order_entry_after_batch_entry_insert();
       public          postgres    false    15            }           1255    304583 ?   thread_order_entry_after_batch_entry_transfer_quantity_delete()    FUNCTION     @  CREATE FUNCTION public.thread_order_entry_after_batch_entry_transfer_quantity_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE thread.order_entry
        SET
            transfer_quantity = transfer_quantity - OLD.transfer_quantity
        WHERE
            uuid = OLD.order_entry_uuid;
    END;
$$;
 V   DROP FUNCTION public.thread_order_entry_after_batch_entry_transfer_quantity_delete();
       public          postgres    false    15            �           1255    304584 ?   thread_order_entry_after_batch_entry_transfer_quantity_insert()    FUNCTION     @  CREATE FUNCTION public.thread_order_entry_after_batch_entry_transfer_quantity_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE thread.order_entry
        SET
            transfer_quantity = transfer_quantity + NEW.transfer_quantity
        WHERE
            uuid = NEW.order_entry_uuid;
    END;
$$;
 V   DROP FUNCTION public.thread_order_entry_after_batch_entry_transfer_quantity_insert();
       public          postgres    false    15            F           1255    304585 ?   thread_order_entry_after_batch_entry_transfer_quantity_update()    FUNCTION     X  CREATE FUNCTION public.thread_order_entry_after_batch_entry_transfer_quantity_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE thread.order_entry
        SET
            transfer_quantity = transfer_quantity + NEW.transfer_quantity - OLD.transfer_quantity
        WHERE
            uuid = NEW.order_entry_uuid;
    END;
$$;
 V   DROP FUNCTION public.thread_order_entry_after_batch_entry_transfer_quantity_update();
       public          postgres    false    15            �           1255    304586 -   thread_order_entry_after_batch_entry_update()    FUNCTION     \  CREATE FUNCTION public.thread_order_entry_after_batch_entry_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE thread.order_entry
        SET
            production_quantity = production_quantity + NEW.coning_production_quantity - OLD.coning_production_quantity
        WHERE
            uuid = NEW.order_entry_uuid;
    END;
$$;
 D   DROP FUNCTION public.thread_order_entry_after_batch_entry_update();
       public          postgres    false    15            X           1255    304587 +   thread_order_entry_after_challan_received()    FUNCTION     (  CREATE FUNCTION public.thread_order_entry_after_challan_received() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE thread.order_entry
        SET
            warehouse = warehouse - CASE WHEN NEW.received = 1 THEN thread_order_entry.quantity ELSE 0 END + CASE WHEN OLD.received = 1 THEN thread_order_entry.quantity ELSE 0 END,
            delivered = delivered + CASE WHEN NEW.received = 1 THEN thread_order_entry.quantity ELSE 0 END - CASE WHEN OLD.received = 1 THEN thread_order_entry.quantity ELSE 0 END
        FROM 
            (
                SELECT order_entry.uuid, challan_entry.quantity 
                FROM thread.challan_entry 
                LEFT JOIN thread.order_entry ON thread.challan_entry.order_entry_uuid = thread.order_entry.uuid 
                LEFT JOIN thread.challan ON thread.challan_entry.challan_uuid = thread.challan.uuid
                WHERE thread.challan.uuid = NEW.uuid
            ) as thread_order_entry
        WHERE
            thread.order_entry.uuid = thread_order_entry.uuid;

    RETURN NEW;
END;
$$;
 B   DROP FUNCTION public.thread_order_entry_after_challan_received();
       public          postgres    false    15            �           1255    304588 2   zipper_batch_entry_after_batch_production_delete()    FUNCTION     L  CREATE FUNCTION public.zipper_batch_entry_after_batch_production_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE zipper.batch_entry
    SET
        production_quantity_in_kg = production_quantity_in_kg - OLD.production_quantity_in_kg
    WHERE
        uuid = OLD.batch_entry_uuid;

    RETURN OLD;
END;
$$;
 I   DROP FUNCTION public.zipper_batch_entry_after_batch_production_delete();
       public          postgres    false    15            _           1255    304589 2   zipper_batch_entry_after_batch_production_insert()    FUNCTION     L  CREATE FUNCTION public.zipper_batch_entry_after_batch_production_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE zipper.batch_entry
    SET
        production_quantity_in_kg = production_quantity_in_kg + NEW.production_quantity_in_kg
    WHERE
        uuid = NEW.batch_entry_uuid;

    RETURN NEW;
END;
$$;
 I   DROP FUNCTION public.zipper_batch_entry_after_batch_production_insert();
       public          postgres    false    15            �           1255    304590 2   zipper_batch_entry_after_batch_production_update()    FUNCTION     l  CREATE FUNCTION public.zipper_batch_entry_after_batch_production_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE zipper.batch_entry
    SET
        production_quantity_in_kg = production_quantity_in_kg + NEW.production_quantity_in_kg - OLD.production_quantity_in_kg
    WHERE
        uuid = NEW.batch_entry_uuid;

    RETURN NEW;
END;
$$;
 I   DROP FUNCTION public.zipper_batch_entry_after_batch_production_update();
       public          postgres    false    15            K           1255    304591 %   zipper_sfg_after_batch_entry_delete()    FUNCTION     #  CREATE FUNCTION public.zipper_sfg_after_batch_entry_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
  UPDATE zipper.sfg
    SET
        dying_and_iron_prod = dying_and_iron_prod - OLD.production_quantity_in_kg
    WHERE
        uuid = OLD.sfg_uuid;

    RETURN OLD;
END;

$$;
 <   DROP FUNCTION public.zipper_sfg_after_batch_entry_delete();
       public          postgres    false    15            �           1255    304592 %   zipper_sfg_after_batch_entry_insert()    FUNCTION     %  CREATE FUNCTION public.zipper_sfg_after_batch_entry_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE zipper.sfg
    SET
        dying_and_iron_prod = dying_and_iron_prod + NEW.production_quantity_in_kg
    WHERE
        uuid = NEW.sfg_uuid;
    
    RETURN NEW;
END;
$$;
 <   DROP FUNCTION public.zipper_sfg_after_batch_entry_insert();
       public          postgres    false    15            �           1255    304593 %   zipper_sfg_after_batch_entry_update()    FUNCTION     E  CREATE FUNCTION public.zipper_sfg_after_batch_entry_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE zipper.sfg
    SET
        dying_and_iron_prod = dying_and_iron_prod + NEW.production_quantity_in_kg - OLD.production_quantity_in_kg
    WHERE
        uuid = NEW.sfg_uuid;

    RETURN NEW;	
END;



$$;
 <   DROP FUNCTION public.zipper_sfg_after_batch_entry_update();
       public          postgres    false    15            �           1255    304594 (   zipper_sfg_after_batch_received_update()    FUNCTION     $  CREATE FUNCTION public.zipper_sfg_after_batch_received_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE zipper.sfg
    SET
        dying_and_iron_prod = dying_and_iron_prod + CASE WHEN (NEW.received = 1 AND OLD.received = 0) THEN be.production_quantity_in_kg ELSE 0 END - CASE WHEN (NEW.received = 0 AND OLD.received = 1) THEN be.production_quantity_in_kg ELSE 0 END
    FROM zipper.batch_entry be
    WHERE
         zipper.sfg.uuid = be.sfg_uuid AND be.batch_uuid = NEW.uuid;
    RETURN NEW;

RETURN NEW;
      
END;

$$;
 ?   DROP FUNCTION public.zipper_sfg_after_batch_received_update();
       public          postgres    false    15            �           1255    304595 A   assembly_stock_after_die_casting_to_assembly_stock_delete_funct()    FUNCTION     1  CREATE FUNCTION slider.assembly_stock_after_die_casting_to_assembly_stock_delete_funct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update slider.assembly_stock
    UPDATE slider.assembly_stock
    SET
        quantity = quantity - OLD.production_quantity,
        weight = weight - OLD.weight
    WHERE uuid = OLD.assembly_stock_uuid;

    -- die casting body
    UPDATE slider.die_casting
    SET quantity_in_sa = quantity_in_sa + OLD.production_quantity + OLD.wastage
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_body_uuid AND assembly_stock.uuid = OLD.assembly_stock_uuid;

    -- die casting cap
    UPDATE slider.die_casting
    SET quantity_in_sa = quantity_in_sa + OLD.production_quantity + OLD.wastage
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_cap_uuid AND assembly_stock.uuid = OLD.assembly_stock_uuid;

    -- die casting puller
    UPDATE slider.die_casting
    SET quantity_in_sa = quantity_in_sa + OLD.production_quantity + OLD.wastage
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_puller_uuid AND assembly_stock.uuid = OLD.assembly_stock_uuid;

    -- die casting link
    UPDATE slider.die_casting
    SET quantity_in_sa = quantity_in_sa + CASE WHEN OLD.with_link = 1 THEN OLD.production_quantity + OLD.wastage ELSE 0 END
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_link_uuid AND assembly_stock.uuid = OLD.assembly_stock_uuid;

    RETURN OLD;
END;
$$;
 X   DROP FUNCTION slider.assembly_stock_after_die_casting_to_assembly_stock_delete_funct();
       slider          postgres    false    12            {           1255    304596 A   assembly_stock_after_die_casting_to_assembly_stock_insert_funct()    FUNCTION     <  CREATE FUNCTION slider.assembly_stock_after_die_casting_to_assembly_stock_insert_funct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update slider.assembly_stock
    UPDATE slider.assembly_stock
    SET
        quantity = quantity + NEW.production_quantity,
        weight = weight + NEW.weight
    WHERE uuid = NEW.assembly_stock_uuid;

    -- die casting body 
    UPDATE slider.die_casting 
    SET 
        quantity_in_sa = quantity_in_sa - NEW.production_quantity - NEW.wastage
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_body_uuid AND assembly_stock.uuid = NEW.assembly_stock_uuid;

    -- die casting cap
    UPDATE slider.die_casting
    SET quantity_in_sa = quantity_in_sa - NEW.production_quantity - NEW.wastage
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_cap_uuid AND assembly_stock.uuid = NEW.assembly_stock_uuid;

    -- die casting puller
    UPDATE slider.die_casting
    SET quantity_in_sa = quantity_in_sa - NEW.production_quantity - NEW.wastage
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_puller_uuid AND assembly_stock.uuid = NEW.assembly_stock_uuid;

    -- die casting link
    UPDATE slider.die_casting
    SET quantity_in_sa = quantity_in_sa - CASE WHEN NEW.with_link = 1 THEN NEW.production_quantity - NEW.wastage ELSE 0 END
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_link_uuid AND assembly_stock.uuid = NEW.assembly_stock_uuid;

    RETURN NEW;
END;
$$;
 X   DROP FUNCTION slider.assembly_stock_after_die_casting_to_assembly_stock_insert_funct();
       slider          postgres    false    12            u           1255    304597 A   assembly_stock_after_die_casting_to_assembly_stock_update_funct()    FUNCTION     U  CREATE FUNCTION slider.assembly_stock_after_die_casting_to_assembly_stock_update_funct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update slider.assembly_stock
    UPDATE slider.assembly_stock
    SET
        quantity = quantity 
            + NEW.production_quantity
            - OLD.production_quantity,
        weight = weight
            + NEW.weight
            - OLD.weight
    WHERE uuid = NEW.assembly_stock_uuid;

    -- die casting body
    UPDATE slider.die_casting
    SET quantity_in_sa = quantity_in_sa - NEW.production_quantity - NEW.wastage + OLD.production_quantity + OLD.wastage
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_body_uuid AND assembly_stock.uuid = NEW.assembly_stock_uuid;

    -- die casting cap
    UPDATE slider.die_casting
    SET quantity_in_sa = quantity_in_sa - NEW.production_quantity - NEW.wastage + OLD.production_quantity + OLD.wastage
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_cap_uuid AND assembly_stock.uuid = NEW.assembly_stock_uuid;

    -- die casting puller
    UPDATE slider.die_casting
    SET quantity_in_sa = quantity_in_sa - NEW.production_quantity - NEW.wastage + OLD.production_quantity + OLD.wastage
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_puller_uuid AND assembly_stock.uuid = NEW.assembly_stock_uuid;

    -- die casting link
    UPDATE slider.die_casting
    SET quantity_in_sa = quantity_in_sa - CASE WHEN NEW.with_link = 1 THEN NEW.production_quantity + NEW.wastage ELSE 0 END + CASE WHEN OLD.with_link = 1 THEN OLD.production_quantity + OLD.wastage ELSE 0 END
    FROM slider.assembly_stock
    WHERE slider.die_casting.uuid = assembly_stock.die_casting_link_uuid AND assembly_stock.uuid = NEW.assembly_stock_uuid;

    RETURN NEW;
END;
$$;
 X   DROP FUNCTION slider.assembly_stock_after_die_casting_to_assembly_stock_update_funct();
       slider          postgres    false    12            �           1255    304598 8   slider_die_casting_after_die_casting_production_delete()    FUNCTION     |  CREATE FUNCTION slider.slider_die_casting_after_die_casting_production_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
--update slider.die_casting table
    UPDATE slider.die_casting
        SET 
        quantity = quantity - (OLD.cavity_goods * OLD.push),
        weight = weight - OLD.weight
        WHERE uuid = OLD.die_casting_uuid;
    RETURN OLD;
    END;
$$;
 O   DROP FUNCTION slider.slider_die_casting_after_die_casting_production_delete();
       slider          postgres    false    12            t           1255    304599 8   slider_die_casting_after_die_casting_production_insert()    FUNCTION     }  CREATE FUNCTION slider.slider_die_casting_after_die_casting_production_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
--update slider.die_casting table
    UPDATE slider.die_casting
        SET 
        quantity = quantity + (NEW.cavity_goods * NEW.push),
        weight = weight + NEW.weight
        WHERE uuid = NEW.die_casting_uuid;
    RETURN NEW;
    END;
$$;
 O   DROP FUNCTION slider.slider_die_casting_after_die_casting_production_insert();
       slider          postgres    false    12            l           1255    304600 8   slider_die_casting_after_die_casting_production_update()    FUNCTION     �  CREATE FUNCTION slider.slider_die_casting_after_die_casting_production_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

--update slider.die_casting table

    UPDATE slider.die_casting
        SET 
        quantity = quantity + (NEW.cavity_goods * NEW.push) - (OLD.cavity_goods * OLD.push),
        weight = weight + NEW.weight - OLD.weight
        WHERE uuid = NEW.die_casting_uuid;
    RETURN NEW;
    END;

$$;
 O   DROP FUNCTION slider.slider_die_casting_after_die_casting_production_update();
       slider          postgres    false    12            z           1255    304601 3   slider_die_casting_after_trx_against_stock_delete()    FUNCTION     �  CREATE FUNCTION slider.slider_die_casting_after_trx_against_stock_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
--update slider.die_casting table
    UPDATE slider.die_casting
        SET 
        quantity_in_sa = quantity_in_sa - OLD.quantity,
        quantity = quantity + OLD.quantity,
        weight = weight + OLD.weight
        WHERE uuid = OLD.die_casting_uuid;
    RETURN OLD;
    END;
$$;
 J   DROP FUNCTION slider.slider_die_casting_after_trx_against_stock_delete();
       slider          postgres    false    12            |           1255    304602 3   slider_die_casting_after_trx_against_stock_insert()    FUNCTION     �  CREATE FUNCTION slider.slider_die_casting_after_trx_against_stock_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
--update slider.die_casting table
    UPDATE slider.die_casting
        SET 
        quantity_in_sa = quantity_in_sa + NEW.quantity,
        quantity = quantity - NEW.quantity,
        weight = weight - NEW.weight
        WHERE uuid = NEW.die_casting_uuid;

    RETURN NEW;
END;
$$;
 J   DROP FUNCTION slider.slider_die_casting_after_trx_against_stock_insert();
       slider          postgres    false    12            C           1255    304603 3   slider_die_casting_after_trx_against_stock_update()    FUNCTION     �  CREATE FUNCTION slider.slider_die_casting_after_trx_against_stock_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
--update slider.die_casting table
    UPDATE slider.die_casting
        SET 

        quantity_in_sa = quantity_in_sa + NEW.quantity - OLD.quantity,
        quantity = quantity - NEW.quantity + OLD.quantity,
        weight = weight - NEW.weight + OLD.weight
        WHERE uuid = NEW.die_casting_uuid;

    RETURN NEW;
END;
$$;
 J   DROP FUNCTION slider.slider_die_casting_after_trx_against_stock_update();
       slider          postgres    false    12            �           1255    304604 0   slider_stock_after_coloring_transaction_delete()    FUNCTION       CREATE FUNCTION slider.slider_stock_after_coloring_transaction_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update slider.stock table
    UPDATE slider.stock
    SET
        sa_prod = CASE WHEN uuid = OLD.stock_uuid THEN sa_prod + OLD.trx_quantity ELSE sa_prod END,
        coloring_stock = CASE WHEN order_info_uuid = OLD.order_info_uuid THEN coloring_stock - OLD.trx_quantity ELSE coloring_stock END

    WHERE uuid = OLD.stock_uuid OR order_info_uuid = OLD.order_info_uuid;

    RETURN OLD;
END;

$$;
 G   DROP FUNCTION slider.slider_stock_after_coloring_transaction_delete();
       slider          postgres    false    12            j           1255    304605 0   slider_stock_after_coloring_transaction_insert()    FUNCTION       CREATE FUNCTION slider.slider_stock_after_coloring_transaction_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update slider.stock table
    UPDATE slider.stock
    SET
        sa_prod = CASE WHEN uuid = NEW.stock_uuid THEN sa_prod - NEW.trx_quantity ELSE sa_prod END,
        coloring_stock = CASE WHEN order_info_uuid = NEW.order_info_uuid THEN coloring_stock + NEW.trx_quantity ELSE coloring_stock END

    WHERE uuid = NEW.stock_uuid OR order_info_uuid = NEW.order_info_uuid;

    RETURN NEW;
END;
$$;
 G   DROP FUNCTION slider.slider_stock_after_coloring_transaction_insert();
       slider          postgres    false    12            p           1255    304606 0   slider_stock_after_coloring_transaction_update()    FUNCTION     7  CREATE FUNCTION slider.slider_stock_after_coloring_transaction_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
    -- Update slider.stock table
    UPDATE slider.stock
    SET
        sa_prod = CASE WHEN uuid = NEW.stock_uuid THEN sa_prod - NEW.trx_quantity + OLD.trx_quantity ELSE sa_prod END,
        coloring_stock = CASE WHEN order_info_uuid = NEW.order_info_uuid THEN coloring_stock + NEW.trx_quantity - OLD.trx_quantity ELSE coloring_stock END

    WHERE uuid = NEW.stock_uuid OR order_info_uuid = NEW.order_info_uuid;

    RETURN NEW;
END;

$$;
 G   DROP FUNCTION slider.slider_stock_after_coloring_transaction_update();
       slider          postgres    false    12            f           1255    304607 3   slider_stock_after_die_casting_transaction_delete()    FUNCTION     �  CREATE FUNCTION slider.slider_stock_after_die_casting_transaction_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 UPDATE slider.die_casting
    SET
        quantity = quantity + OLD.trx_quantity,
        weight = weight + OLD.weight
    WHERE uuid = OLD.die_casting_uuid;

    --update slider.stock table
    UPDATE slider.stock
    SET
        body_quantity = body_quantity 
            - CASE WHEN dc.type = 'body' THEN OLD.trx_quantity ELSE 0 END,
        puller_quantity = puller_quantity 
            - CASE WHEN dc.type = 'puller' THEN OLD.trx_quantity ELSE 0 END,
        cap_quantity = cap_quantity 
            - CASE WHEN dc.type = 'cap' THEN OLD.trx_quantity ELSE 0 END,
        link_quantity = link_quantity 
            - CASE WHEN dc.type = 'link' THEN OLD.trx_quantity ELSE 0 END,
        h_bottom_quantity = h_bottom_quantity 
            - CASE WHEN dc.type = 'h_bottom' THEN OLD.trx_quantity ELSE 0 END,
        u_top_quantity = u_top_quantity 
            - CASE WHEN dc.type = 'u_top' THEN OLD.trx_quantity ELSE 0 END,
        box_pin_quantity = box_pin_quantity 
            - CASE WHEN dc.type = 'box_pin' THEN OLD.trx_quantity ELSE 0 END,
        two_way_pin_quantity = two_way_pin_quantity 
            - CASE WHEN dc.type = 'two_way_pin' THEN OLD.trx_quantity ELSE 0 END
    FROM slider.die_casting dc
    WHERE stock.uuid = NEW.stock_uuid AND dc.uuid = NEW.die_casting_uuid;


RETURN OLD;
END;

$$;
 J   DROP FUNCTION slider.slider_stock_after_die_casting_transaction_delete();
       slider          postgres    false    12            �           1255    304608 3   slider_stock_after_die_casting_transaction_insert()    FUNCTION     �  CREATE FUNCTION slider.slider_stock_after_die_casting_transaction_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    --update slider.stock table
    UPDATE slider.die_casting
    SET
        quantity = quantity - NEW.trx_quantity,
        weight = weight - NEW.weight
    WHERE uuid = NEW.die_casting_uuid;

    UPDATE slider.stock
    SET
        body_quantity = body_quantity 
            + CASE WHEN dc.type = 'body' THEN NEW.trx_quantity ELSE 0 END,
        puller_quantity = puller_quantity 
            + CASE WHEN dc.type = 'puller' THEN NEW.trx_quantity ELSE 0 END,
        cap_quantity = cap_quantity 
            + CASE WHEN dc.type = 'cap' THEN NEW.trx_quantity ELSE 0 END,
        link_quantity = link_quantity 
            + CASE WHEN dc.type = 'link' THEN NEW.trx_quantity ELSE 0 END,
        h_bottom_quantity = h_bottom_quantity 
            + CASE WHEN dc.type = 'h_bottom' THEN NEW.trx_quantity ELSE 0 END,
        u_top_quantity = u_top_quantity 
            + CASE WHEN dc.type = 'u_top' THEN NEW.trx_quantity ELSE 0 END,
        box_pin_quantity = box_pin_quantity 
            + CASE WHEN dc.type = 'box_pin' THEN NEW.trx_quantity ELSE 0 END,
        two_way_pin_quantity = two_way_pin_quantity 
            + CASE WHEN dc.type = 'two_way_pin' THEN NEW.trx_quantity ELSE 0 END
    FROM slider.die_casting dc
    WHERE stock.uuid = NEW.stock_uuid AND dc.uuid = NEW.die_casting_uuid;

RETURN NEW;
END;
$$;
 J   DROP FUNCTION slider.slider_stock_after_die_casting_transaction_insert();
       slider          postgres    false    12            �           1255    304609 3   slider_stock_after_die_casting_transaction_update()    FUNCTION     *  CREATE FUNCTION slider.slider_stock_after_die_casting_transaction_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    --update slider.stock table
    UPDATE slider.die_casting
    SET
        quantity = quantity - NEW.trx_quantity + OLD.trx_quantity,
        weight = weight - NEW.weight + OLD.weight
    WHERE uuid = NEW.die_casting_uuid;

    UPDATE slider.stock
    SET
        body_quantity = body_quantity 
            + CASE WHEN dc.type = 'body' THEN NEW.trx_quantity ELSE 0 END 
            - CASE WHEN dc.type = 'body' THEN OLD.trx_quantity ELSE 0 END,
        puller_quantity = puller_quantity 
            + CASE WHEN dc.type = 'puller' THEN NEW.trx_quantity ELSE 0 END 
            - CASE WHEN dc.type = 'puller' THEN OLD.trx_quantity ELSE 0 END,
        cap_quantity = cap_quantity 
            + CASE WHEN dc.type = 'cap' THEN NEW.trx_quantity ELSE 0 END 
            - CASE WHEN dc.type = 'cap' THEN OLD.trx_quantity ELSE 0 END,
        link_quantity = link_quantity 
            + CASE WHEN dc.type = 'link' THEN NEW.trx_quantity ELSE 0 END 
            - CASE WHEN dc.type = 'link' THEN OLD.trx_quantity ELSE 0 END,
        h_bottom_quantity = h_bottom_quantity 
            + CASE WHEN dc.type = 'h_bottom' THEN NEW.trx_quantity ELSE 0 END 
            - CASE WHEN dc.type = 'h_bottom' THEN OLD.trx_quantity ELSE 0 END,
        u_top_quantity = u_top_quantity 
            + CASE WHEN dc.type = 'u_top' THEN NEW.trx_quantity ELSE 0 END 
            - CASE WHEN dc.type = 'u_top' THEN OLD.trx_quantity ELSE 0 END,
        box_pin_quantity = box_pin_quantity 
            + CASE WHEN dc.type = 'box_pin' THEN NEW.trx_quantity ELSE 0 END 
            - CASE WHEN dc.type = 'box_pin' THEN OLD.trx_quantity ELSE 0 END,
        two_way_pin_quantity = two_way_pin_quantity 
            + CASE WHEN dc.type = 'two_way_pin' THEN NEW.trx_quantity ELSE 0 END 
            - CASE WHEN dc.type = 'two_way_pin' THEN OLD.trx_quantity ELSE 0 END
    FROM slider.die_casting dc
    WHERE stock.uuid = NEW.stock_uuid AND dc.uuid = NEW.die_casting_uuid;

RETURN NEW;
END;

$$;
 J   DROP FUNCTION slider.slider_stock_after_die_casting_transaction_update();
       slider          postgres    false    12            �           1255    304610 -   slider_stock_after_slider_production_delete()    FUNCTION     �  CREATE FUNCTION slider.slider_stock_after_slider_production_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   
    -- Update slider.stock table for 'sa_prod' section
    IF OLD.section = 'sa_prod' THEN
        UPDATE slider.stock
        SET
            sa_prod = sa_prod - OLD.production_quantity,
            body_quantity =  body_quantity + OLD.production_quantity,
            cap_quantity = cap_quantity + OLD.production_quantity,
            puller_quantity = puller_quantity + OLD.production_quantity,
            link_quantity = link_quantity + CASE WHEN OLD.with_link = 1 THEN OLD.production_quantity ELSE 0 END
        FROM zipper.v_order_details_full vodf
        WHERE vodf.order_description_uuid = stock.order_description_uuid AND stock.uuid = OLD.stock_uuid;
    END IF;

    -- Update slider.stock table for 'coloring' section
    IF OLD.section = 'coloring' THEN
        UPDATE slider.stock
        SET
            coloring_stock = coloring_stock + OLD.production_quantity,
            link_quantity = link_quantity + OLD.production_quantity,
            box_pin_quantity = box_pin_quantity + CASE WHEN lower(vodf.end_type_name) = 'open end' THEN OLD.production_quantity ELSE 0 END,
            h_bottom_quantity = h_bottom_quantity + CASE WHEN lower(vodf.end_type_name) = 'close end' THEN OLD.production_quantity ELSE 0 END,
            u_top_quantity = u_top_quantity + (2 * OLD.production_quantity),
            coloring_prod = coloring_prod - OLD.production_quantity
        FROM zipper.v_order_details_full vodf
        WHERE vodf.order_description_uuid = stock.order_description_uuid AND stock.uuid = OLD.stock_uuid;
    END IF;

    RETURN OLD;
END;
$$;
 D   DROP FUNCTION slider.slider_stock_after_slider_production_delete();
       slider          postgres    false    12            �           1255    304611 -   slider_stock_after_slider_production_insert()    FUNCTION     o  CREATE FUNCTION slider.slider_stock_after_slider_production_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update slider.stock table for 'sa_prod' section
   
      IF NEW.section = 'sa_prod' THEN
            UPDATE slider.stock
            SET
                sa_prod = sa_prod + NEW.production_quantity,
                body_quantity =  body_quantity - NEW.production_quantity,
                cap_quantity = cap_quantity - NEW.production_quantity,
                puller_quantity = puller_quantity - NEW.production_quantity,
                link_quantity = link_quantity - CASE WHEN NEW.with_link = 1 THEN NEW.production_quantity ELSE 0 END
            WHERE stock.uuid = NEW.stock_uuid;
    END IF;

-- Update slider.stock table for 'coloring' section

    IF NEW.section = 'coloring' THEN

        UPDATE slider.stock
            SET
                coloring_stock = coloring_stock - NEW.production_quantity,
                link_quantity = link_quantity - NEW.production_quantity,
                box_pin_quantity = box_pin_quantity - CASE WHEN lower(vodf.end_type_name) = 'open end' THEN NEW.production_quantity ELSE 0 END,
                h_bottom_quantity = h_bottom_quantity - CASE WHEN lower(vodf.end_type_name) = 'close end' THEN NEW.production_quantity ELSE 0 END,
                u_top_quantity = u_top_quantity - (2 * NEW.production_quantity),
                coloring_prod = coloring_prod + NEW.production_quantity
            FROM zipper.v_order_details_full vodf
        WHERE vodf.order_description_uuid = stock.order_description_uuid AND stock.uuid = NEW.stock_uuid;
    END IF;

    RETURN NEW;
END;
$$;
 D   DROP FUNCTION slider.slider_stock_after_slider_production_insert();
       slider          postgres    false    12            v           1255    304612 -   slider_stock_after_slider_production_update()    FUNCTION     {  CREATE FUNCTION slider.slider_stock_after_slider_production_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update slider.stock table for 'sa_prod' section
    IF NEW.section = 'sa_prod' THEN
        UPDATE slider.stock
        SET
            sa_prod = sa_prod + NEW.production_quantity - OLD.production_quantity,
            body_quantity =  body_quantity - NEW.production_quantity + OLD.production_quantity,
            cap_quantity = cap_quantity - NEW.production_quantity + OLD.production_quantity,
            puller_quantity = puller_quantity - NEW.production_quantity + OLD.production_quantity,
            link_quantity = link_quantity - CASE WHEN NEW.with_link = 1 THEN NEW.production_quantity ELSE 0 END + CASE WHEN OLD.with_link = 1 THEN OLD.production_quantity ELSE 0 END
        WHERE stock.uuid = NEW.stock_uuid;
    END IF;

    -- Update slider.stock table for 'coloring' section
    IF NEW.section = 'coloring' THEN
        UPDATE slider.stock
        SET
            coloring_stock = coloring_stock - NEW.production_quantity + OLD.production_quantity,
            link_quantity = link_quantity - NEW.production_quantity + OLD.production_quantity,
            box_pin_quantity = box_pin_quantity - CASE WHEN lower(vodf.end_type_name) = 'open end' THEN NEW.production_quantity - OLD.production_quantity ELSE 0 END,
            h_bottom_quantity = h_bottom_quantity - CASE WHEN lower(vodf.end_type_name) = 'close end' THEN NEW.production_quantity - OLD.production_quantity ELSE 0 END,
            u_top_quantity = u_top_quantity - (2 * (NEW.production_quantity - OLD.production_quantity)),
            coloring_prod = coloring_prod + NEW.production_quantity - OLD.production_quantity
            FROM zipper.v_order_details_full vodf
        WHERE vodf.order_description_uuid = stock.order_description_uuid AND stock.uuid = NEW.stock_uuid;
    END IF;

    RETURN NEW;
END;
$$;
 D   DROP FUNCTION slider.slider_stock_after_slider_production_update();
       slider          postgres    false    12            �           1255    304613 '   slider_stock_after_transaction_delete()    FUNCTION     �  CREATE FUNCTION slider.slider_stock_after_transaction_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    --update slider.stock table
    UPDATE slider.stock
    SET
        sa_prod = sa_prod + CASE WHEN OLD.from_section = 'sa_prod' THEN OLD.trx_quantity ELSE 0 END
        - CASE WHEN OLD.to_section = 'sa_prod' THEN OLD.trx_quantity ELSE 0 END,
        coloring_stock = coloring_stock + CASE WHEN OLD.from_section = 'coloring_stock' THEN OLD.trx_quantity ELSE 0 END
        - CASE WHEN OLD.to_section = 'coloring_stock' THEN OLD.trx_quantity ELSE 0 END
    WHERE uuid = OLD.stock_uuid;

    IF OLD.from_section = 'coloring_prod' AND OLD.to_section = 'trx_to_finishing'
    THEN
        UPDATE slider.stock
        SET
        coloring_prod = coloring_prod + OLD.trx_quantity,
        trx_to_finishing = trx_to_finishing - OLD.trx_quantity
        WHERE uuid = OLD.stock_uuid;

        UPDATE zipper.order_description
        SET
        slider_finishing_stock = slider_finishing_stock - OLD.trx_quantity
        WHERE uuid = (SELECT order_description_uuid FROM slider.stock WHERE uuid = OLD.stock_uuid);
        
    END IF;

    IF OLD.assembly_stock_uuid IS NOT NULL
    THEN
        UPDATE slider.stock
        SET
            coloring_stock = coloring_stock - CASE WHEN OLD.to_section = 'assembly_stock_to_coloring_stock' THEN OLD.trx_quantity ELSE 0 END
        WHERE uuid = OLD.stock_uuid;

        UPDATE slider.assembly_stock
        SET
            quantity = quantity + CASE WHEN OLD.from_section = 'assembly_stock' THEN OLD.trx_quantity ELSE 0 END,
            weight = weight + CASE WHEN OLD.from_section = 'assembly_stock' THEN OLD.weight ELSE 0 END
        WHERE uuid = OLD.assembly_stock_uuid;
    END IF;

    RETURN OLD;
END;
$$;
 >   DROP FUNCTION slider.slider_stock_after_transaction_delete();
       slider          postgres    false    12            Q           1255    304614 '   slider_stock_after_transaction_insert()    FUNCTION     �  CREATE FUNCTION slider.slider_stock_after_transaction_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    --update slider.stock table
    UPDATE slider.stock
    SET
        sa_prod = sa_prod - CASE WHEN NEW.from_section = 'sa_prod' THEN NEW.trx_quantity ELSE 0 END
        + CASE WHEN NEW.to_section = 'sa_prod' THEN NEW.trx_quantity ELSE 0 END,
        coloring_stock = coloring_stock - CASE WHEN NEW.from_section = 'coloring_stock' THEN NEW.trx_quantity ELSE 0 END
        + CASE WHEN NEW.to_section = 'coloring_stock' THEN NEW.trx_quantity ELSE 0 END
    WHERE uuid = NEW.stock_uuid;

    IF NEW.from_section = 'coloring_prod' AND NEW.to_section = 'trx_to_finishing'
    THEN
        UPDATE slider.stock
        SET
        coloring_prod = coloring_prod - NEW.trx_quantity,
        trx_to_finishing = trx_to_finishing + NEW.trx_quantity
        WHERE uuid = NEW.stock_uuid;

        UPDATE zipper.order_description
        SET
        slider_finishing_stock = slider_finishing_stock + NEW.trx_quantity
        WHERE uuid = (SELECT order_description_uuid FROM slider.stock WHERE uuid = NEW.stock_uuid);
    END IF;

    IF NEW.assembly_stock_uuid IS NOT NULL
    THEN
        UPDATE slider.stock
        SET
            coloring_stock = coloring_stock + CASE WHEN NEW.to_section = 'assembly_stock_to_coloring_stock' THEN NEW.trx_quantity ELSE 0 END
        WHERE uuid = NEW.stock_uuid;

        UPDATE slider.assembly_stock
        SET
            quantity = quantity - CASE WHEN NEW.from_section = 'assembly_stock' THEN NEW.trx_quantity ELSE 0 END,
            weight = weight - CASE WHEN NEW.from_section = 'assembly_stock' THEN NEW.weight ELSE 0 END
        WHERE uuid = NEW.assembly_stock_uuid;
    END IF;

    RETURN NEW;
END;
$$;
 >   DROP FUNCTION slider.slider_stock_after_transaction_insert();
       slider          postgres    false    12            V           1255    304615 '   slider_stock_after_transaction_update()    FUNCTION     `  CREATE FUNCTION slider.slider_stock_after_transaction_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    --update slider.stock table
    UPDATE slider.stock
    SET
        
        sa_prod = sa_prod 
        - CASE WHEN NEW.from_section = 'sa_prod' THEN NEW.trx_quantity ELSE 0 END
        + CASE WHEN NEW.to_section = 'sa_prod' THEN NEW.trx_quantity ELSE 0 END
        + CASE WHEN OLD.from_section = 'sa_prod' THEN OLD.trx_quantity ELSE 0 END
        - CASE WHEN OLD.to_section = 'sa_prod' THEN OLD.trx_quantity ELSE 0 END,
        coloring_stock = coloring_stock 
        - CASE WHEN NEW.from_section = 'coloring_stock' THEN NEW.trx_quantity ELSE 0 END
        + CASE WHEN NEW.to_section = 'coloring_stock' THEN NEW.trx_quantity ELSE 0 END
        + CASE WHEN OLD.from_section = 'coloring_stock' THEN OLD.trx_quantity ELSE 0 END
        - CASE WHEN OLD.to_section = 'coloring_stock' THEN OLD.trx_quantity ELSE 0 END
    WHERE uuid = NEW.stock_uuid;

    IF NEW.from_section = 'coloring_prod' AND NEW.to_section = 'trx_to_finishing'
    THEN
        UPDATE slider.stock
        SET
        coloring_prod = coloring_prod - NEW.trx_quantity + OLD.trx_quantity,
        trx_to_finishing = trx_to_finishing + NEW.trx_quantity - OLD.trx_quantity
        WHERE uuid = NEW.stock_uuid;

        UPDATE zipper.order_description
        SET
        slider_finishing_stock = slider_finishing_stock + NEW.trx_quantity - OLD.trx_quantity
        WHERE uuid = (SELECT order_description_uuid FROM slider.stock WHERE uuid = NEW.stock_uuid);
        
    END IF;

    -- assembly_stock_uuid -> OLD
    IF OLD.assembly_stock_uuid IS NOT NULL
    THEN
        UPDATE slider.stock
        SET
            coloring_stock = coloring_stock 
            - CASE WHEN OLD.to_section = 'assembly_stock_to_coloring_stock' THEN OLD.trx_quantity ELSE 0 END
        WHERE uuid = OLD.stock_uuid;

        UPDATE slider.assembly_stock
        SET
            quantity = quantity 
            + CASE WHEN OLD.from_section = 'assembly_stock' THEN OLD.trx_quantity ELSE 0 END,
            weight = weight
            + CASE WHEN OLD.from_section = 'assembly_stock' THEN OLD.weight ELSE 0 END
        WHERE uuid = OLD.assembly_stock_uuid;
    END IF;

    -- assembly_stock_uuid -> NEW
    IF NEW.assembly_stock_uuid IS NOT NULL
    THEN
        UPDATE slider.stock
        SET
            coloring_stock = coloring_stock + CASE WHEN NEW.to_section = 'assembly_stock_to_coloring_stock' THEN NEW.trx_quantity ELSE 0 END
        WHERE uuid = NEW.stock_uuid;

        UPDATE slider.assembly_stock
        SET
            quantity = quantity 
            - CASE WHEN NEW.from_section = 'assembly_stock' THEN NEW.trx_quantity ELSE 0 END,
            weight = weight
            - CASE WHEN NEW.from_section = 'assembly_stock' THEN NEW.weight ELSE 0 END
        WHERE uuid = NEW.assembly_stock_uuid;
    END IF;

    RETURN NEW;
END;
$$;
 >   DROP FUNCTION slider.slider_stock_after_transaction_update();
       slider          postgres    false    12            �           1255    304616 *   order_entry_after_batch_is_drying_update()    FUNCTION     �  CREATE FUNCTION thread.order_entry_after_batch_is_drying_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Handle insert when is_drying_complete is true

    IF TG_OP = 'UPDATE' AND NEW.is_drying_complete = '1' THEN
        -- Update order_entry table
        UPDATE thread.order_entry
        SET production_quantity = production_quantity + NEW.quantity
        WHERE uuid = (SELECT order_entry_uuid FROM thread.batch_entry WHERE batch_uuid = NEW.uuid);

        -- Update batch_entry table
        UPDATE thread.batch_entry
        SET quantity = quantity - NEW.quantity
        WHERE batch_uuid = NEW.uuid;

    -- Handle remove when is_drying_complete changes from true to false

    ELSIF TG_OP = 'UPDATE' AND OLD.is_drying_complete = '1' AND NEW.is_drying_complete = '0' THEN
        -- Update order_entry table
        UPDATE thread.order_entry
        SET production_quantity = production_quantity - OLD.quantity
        WHERE uuid = (SELECT order_entry_uuid FROM thread.batch_entry WHERE batch_uuid = NEW.uuid);

        -- Update batch_entry table
        UPDATE thread.batch_entry
        SET quantity = quantity + OLD.quantity
        WHERE batch_uuid = NEW.uuid;
    END IF;

    RETURN NEW;
END;
$$;
 A   DROP FUNCTION thread.order_entry_after_batch_is_drying_update();
       thread          postgres    false    13            �           1255    304617 *   order_entry_after_batch_is_dyeing_update()    FUNCTION       CREATE FUNCTION thread.order_entry_after_batch_is_dyeing_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'Trigger executing for batch UUID: %', NEW.uuid;

    -- Update order_entry
    UPDATE thread.order_entry oe
    SET 
        production_quantity = production_quantity 
        + CASE WHEN (NEW.is_drying_complete = 'true' AND OLD.is_drying_complete = 'false') THEN be.quantity ELSE 0 END 
        - CASE WHEN (NEW.is_drying_complete = 'false' AND OLD.is_drying_complete = 'true') THEN be.quantity ELSE 0 END
    FROM thread.batch_entry be
    LEFT JOIN thread.batch b ON be.batch_uuid = b.uuid
    WHERE b.uuid = NEW.uuid AND oe.uuid = be.order_entry_uuid;
    RAISE NOTICE 'Trigger executed for batch UUID: %', NEW.uuid;
    RETURN NEW;
END;
$$;
 A   DROP FUNCTION thread.order_entry_after_batch_is_dyeing_update();
       thread          postgres    false    13            S           1255    304618 6   multi_color_dashboard_after_order_description_delete()    FUNCTION       CREATE FUNCTION zipper.multi_color_dashboard_after_order_description_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD.is_multi_color = 1 THEN
        DELETE FROM zipper.multi_color_dashboard
        WHERE order_description_uuid = OLD.uuid;
    END IF;
END;
$$;
 M   DROP FUNCTION zipper.multi_color_dashboard_after_order_description_delete();
       zipper          postgres    false    14            �           1255    304619 6   multi_color_dashboard_after_order_description_insert()    FUNCTION     ~  CREATE FUNCTION zipper.multi_color_dashboard_after_order_description_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.is_multi_color = 1 THEN
        INSERT INTO zipper.multi_color_dashboard (
            uuid, 
            order_description_uuid
        ) VALUES (
            NEW.uuid, 
            NEW.uuid
        );
    END IF;
    RETURN NEW;
END;
$$;
 M   DROP FUNCTION zipper.multi_color_dashboard_after_order_description_insert();
       zipper          postgres    false    14            �           1255    304620 6   multi_color_dashboard_after_order_description_update()    FUNCTION     �  CREATE FUNCTION zipper.multi_color_dashboard_after_order_description_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- if is_multi_color is updated to 1 then insert into multi_color_dashboard table
    IF NEW.is_multi_color = 1 AND OLD.is_multi_color = 0 THEN
        INSERT INTO zipper.multi_color_dashboard (
            uuid, 
            order_description_uuid
        ) VALUES (
            NEW.uuid, 
            NEW.uuid
        );
    -- if is_multi_color is updated to 0 then delete from multi_color_dashboard table
    ELSIF NEW.is_multi_color = 0 AND OLD.is_multi_color = 1 THEN
        DELETE FROM zipper.multi_color_dashboard
        WHERE order_description_uuid = NEW.uuid;
    END IF;
    RETURN NEW;
END;
$$;
 M   DROP FUNCTION zipper.multi_color_dashboard_after_order_description_update();
       zipper          postgres    false    14            h           1255    304621 6   order_description_after_dyed_tape_transaction_delete()    FUNCTION     �  CREATE FUNCTION zipper.order_description_after_dyed_tape_transaction_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update order_description
    UPDATE zipper.order_description
    SET
        tape_received = tape_received + OLD.trx_quantity,
        tape_transferred = tape_transferred - OLD.trx_quantity
    WHERE order_description.uuid = OLD.order_description_uuid;

    RETURN OLD;
END;

$$;
 M   DROP FUNCTION zipper.order_description_after_dyed_tape_transaction_delete();
       zipper          postgres    false    14            \           1255    304622 6   order_description_after_dyed_tape_transaction_insert()    FUNCTION     �  CREATE FUNCTION zipper.order_description_after_dyed_tape_transaction_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
    -- Update order_description
    UPDATE zipper.order_description
    SET
        tape_received = tape_received - NEW.trx_quantity,
        tape_transferred = tape_transferred + NEW.trx_quantity
    WHERE order_description.uuid = NEW.order_description_uuid;

    RETURN NEW;
END;

$$;
 M   DROP FUNCTION zipper.order_description_after_dyed_tape_transaction_insert();
       zipper          postgres    false    14            J           1255    304623 6   order_description_after_dyed_tape_transaction_update()    FUNCTION     �  CREATE FUNCTION zipper.order_description_after_dyed_tape_transaction_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update order_description
    UPDATE zipper.order_description
    SET
        tape_received = tape_received + OLD.trx_quantity - NEW.trx_quantity,
        tape_transferred = tape_transferred + NEW.trx_quantity - OLD.trx_quantity
    WHERE order_description.uuid = NEW.order_description_uuid;

    RETURN NEW;
END;

$$;
 M   DROP FUNCTION zipper.order_description_after_dyed_tape_transaction_update();
       zipper          postgres    false    14            H           1255    304624 9   order_description_after_multi_color_tape_receive_delete()    FUNCTION     a  CREATE FUNCTION zipper.order_description_after_multi_color_tape_receive_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update order_description
    UPDATE zipper.order_description
    SET
        tape_received = tape_received - OLD.quantity
    WHERE order_description.uuid = OLD.order_description_uuid;

    RETURN OLD;
END;

$$;
 P   DROP FUNCTION zipper.order_description_after_multi_color_tape_receive_delete();
       zipper          postgres    false    14            M           1255    304625 9   order_description_after_multi_color_tape_receive_insert()    FUNCTION     b  CREATE FUNCTION zipper.order_description_after_multi_color_tape_receive_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
    -- Update order_description
    UPDATE zipper.order_description
    SET
        tape_received = tape_received + NEW.quantity
    WHERE order_description.uuid = NEW.order_description_uuid;

    RETURN NEW;
END;

$$;
 P   DROP FUNCTION zipper.order_description_after_multi_color_tape_receive_insert();
       zipper          postgres    false    14            �           1255    304626 9   order_description_after_multi_color_tape_receive_update()    FUNCTION     p  CREATE FUNCTION zipper.order_description_after_multi_color_tape_receive_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update order_description
    UPDATE zipper.order_description
    SET
        tape_received = tape_received - OLD.quantity + NEW.quantity
    WHERE order_description.uuid = NEW.order_description_uuid;

    RETURN NEW;
END;

$$;
 P   DROP FUNCTION zipper.order_description_after_multi_color_tape_receive_update();
       zipper          postgres    false    14            �           1255    304627 4   order_description_after_tape_coil_to_dyeing_delete()    FUNCTION       CREATE FUNCTION zipper.order_description_after_tape_coil_to_dyeing_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE zipper.tape_coil
        SET
            quantity_in_coil = CASE WHEN lower(properties.name) = 'nylon' THEN quantity_in_coil + OLD.trx_quantity ELSE quantity_in_coil END,
            quantity = CASE WHEN lower(properties.name) = 'nylon' THEN quantity ELSE quantity + OLD.trx_quantity END
        FROM public.properties
        WHERE tape_coil.uuid = OLD.tape_coil_uuid AND properties.uuid = tape_coil.item_uuid;

        UPDATE zipper.order_description
        SET
            tape_received = tape_received - OLD.trx_quantity
        WHERE uuid = OLD.order_description_uuid AND is_multi_color = 0;

        RETURN OLD;
    END;
$$;
 K   DROP FUNCTION zipper.order_description_after_tape_coil_to_dyeing_delete();
       zipper          postgres    false    14            �           1255    304628 4   order_description_after_tape_coil_to_dyeing_insert()    FUNCTION     +  CREATE FUNCTION zipper.order_description_after_tape_coil_to_dyeing_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE zipper.tape_coil
    SET
        quantity_in_coil = CASE WHEN lower(properties.name) = 'nylon' THEN quantity_in_coil - NEW.trx_quantity ELSE quantity_in_coil END,
        quantity = CASE WHEN lower(properties.name) = 'nylon' THEN quantity ELSE quantity - NEW.trx_quantity END
    FROM public.properties
    WHERE tape_coil.uuid = NEW.tape_coil_uuid AND properties.uuid = tape_coil.item_uuid;
    -- TODO: if is_multi_color is 1 then Do not update the zipper.order_description
    UPDATE zipper.order_description
    SET
        tape_received = tape_received + NEW.trx_quantity
    WHERE uuid = NEW.order_description_uuid AND is_multi_color = 0;

    RETURN NEW;
END;
$$;
 K   DROP FUNCTION zipper.order_description_after_tape_coil_to_dyeing_insert();
       zipper          postgres    false    14            a           1255    304629 4   order_description_after_tape_coil_to_dyeing_update()    FUNCTION       CREATE FUNCTION zipper.order_description_after_tape_coil_to_dyeing_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE zipper.tape_coil
    SET
        quantity_in_coil = CASE WHEN lower(properties.name) = 'nylon' THEN quantity_in_coil + OLD.trx_quantity - NEW.trx_quantity ELSE quantity_in_coil END,
        quantity = CASE WHEN lower(properties.name) = 'nylon' THEN quantity ELSE quantity + OLD.trx_quantity - NEW.trx_quantity END
    FROM public.properties
    WHERE tape_coil.uuid = NEW.tape_coil_uuid AND properties.uuid = tape_coil.item_uuid;

    UPDATE zipper.order_description
    SET
        tape_received = tape_received - OLD.trx_quantity + NEW.trx_quantity
    WHERE uuid = NEW.order_description_uuid AND is_multi_color = 0;

    RETURN NEW;
END;

$$;
 K   DROP FUNCTION zipper.order_description_after_tape_coil_to_dyeing_update();
       zipper          postgres    false    14                       1255    304630    sfg_after_order_entry_delete()    FUNCTION     �   CREATE FUNCTION zipper.sfg_after_order_entry_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM zipper.sfg
    WHERE order_entry_uuid = OLD.uuid;
    RETURN OLD;
END;
$$;
 5   DROP FUNCTION zipper.sfg_after_order_entry_delete();
       zipper          postgres    false    14            �           1255    304631    sfg_after_order_entry_insert()    FUNCTION       CREATE FUNCTION zipper.sfg_after_order_entry_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO zipper.sfg (
        uuid, 
        order_entry_uuid
    ) VALUES (
        NEW.uuid, 
        NEW.uuid
    );
    RETURN NEW;
END;
$$;
 5   DROP FUNCTION zipper.sfg_after_order_entry_insert();
       zipper          postgres    false    14            �           1255    304632 *   sfg_after_sfg_production_delete_function()    FUNCTION     �  CREATE FUNCTION zipper.sfg_after_sfg_production_delete_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
    item_name TEXT;
    od_uuid TEXT;
    nylon_stopper_name TEXT;
BEGIN
    -- Fetch item_name and order_description_uuid once
    SELECT vodf.item_name, oe.order_description_uuid, vodf.nylon_stopper_name INTO item_name, od_uuid, nylon_stopper_name
    FROM zipper.sfg sfg
    LEFT JOIN zipper.order_entry oe ON oe.uuid = sfg.order_entry_uuid
    LEFT JOIN zipper.v_order_details_full vodf ON oe.order_description_uuid = vodf.order_description_uuid
    WHERE sfg.uuid = OLD.sfg_uuid;

    -- Update order_description based on item_name
    IF lower(item_name) = 'metal' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred + 
                CASE 
                    WHEN OLD.section = 'teeth_molding' THEN OLD.production_quantity_in_kg + OLD.wastage 
                    ELSE 0
                END,
            slider_finishing_stock = slider_finishing_stock + 
                CASE 
                    WHEN OLD.section = 'finishing' THEN OLD.production_quantity
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;

    ELSIF lower(item_name) = 'vislon' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred + 
                CASE 
                    WHEN OLD.section = 'teeth_molding' THEN 
                        CASE
                            WHEN OLD.production_quantity_in_kg = 0 THEN OLD.production_quantity + OLD.wastage 
                            ELSE OLD.production_quantity_in_kg + OLD.wastage 
                        END
                    ELSE 0
                END,
            slider_finishing_stock = slider_finishing_stock + 
                CASE 
                    WHEN OLD.section = 'finishing' THEN OLD.production_quantity
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;

    ELSIF lower(item_name) = 'nylon' AND lower(nylon_stopper_name) = 'plastic' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred + 
                CASE 
                    WHEN OLD.section = 'finishing' THEN OLD.production_quantity_in_kg + OLD.wastage 
                    ELSE 
                        CASE
                            WHEN OLD.production_quantity_in_kg = 0 THEN OLD.production_quantity + OLD.wastage 
                            ELSE OLD.production_quantity_in_kg + OLD.wastage 
                        END 
                END,
            slider_finishing_stock = slider_finishing_stock + 
                CASE 
                    WHEN OLD.section = 'finishing' THEN OLD.production_quantity
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;

    ELSIF lower(item_name) = 'nylon' AND lower(nylon_stopper_name) = 'metallic' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred + 
                CASE 
                    WHEN OLD.section = 'finishing' THEN OLD.production_quantity_in_kg + OLD.wastage 
                    ELSE 
                        CASE
                            WHEN OLD.production_quantity_in_kg = 0 THEN OLD.production_quantity + OLD.wastage 
                            ELSE OLD.production_quantity_in_kg + OLD.wastage 
                        END 
                END,
            slider_finishing_stock = slider_finishing_stock + 
                CASE 
                    WHEN OLD.section = 'finishing' THEN OLD.production_quantity 
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;
    END IF;

    -- Update sfg table
    UPDATE zipper.sfg sfg
    SET 
        teeth_molding_prod = teeth_molding_prod - 
            CASE 
                WHEN OLD.section = 'teeth_molding' THEN 
                    CASE WHEN lower(vodf.item_name) = 'metal' 
                    THEN OLD.production_quantity 
                    ELSE
                        CASE
                            WHEN OLD.production_quantity_in_kg = 0 THEN OLD.production_quantity 
                            ELSE OLD.production_quantity_in_kg 
                        END 
                    END
                ELSE 0
            END,
        finishing_stock = finishing_stock + 
            CASE 
                WHEN OLD.section = 'finishing' THEN 
                    CASE
                        WHEN OLD.production_quantity_in_kg = 0 THEN OLD.production_quantity + OLD.wastage 
                        ELSE OLD.production_quantity_in_kg + OLD.wastage 
                    END 
                ELSE 0
            END 
            - 
            CASE 
                WHEN OLD.section = 'teeth_coloring' THEN OLD.production_quantity 
                ELSE 0 
            END,
        finishing_prod = finishing_prod - 
            CASE 
                WHEN OLD.section = 'finishing' THEN OLD.production_quantity 
                ELSE 0
            END,
        teeth_coloring_stock = teeth_coloring_stock + 
            CASE 
                WHEN OLD.section = 'teeth_coloring' THEN 
                    CASE 
                        WHEN OLD.production_quantity_in_kg = 0 THEN OLD.production_quantity + OLD.wastage 
                        ELSE OLD.production_quantity_in_kg + OLD.wastage 
                    END 
                ELSE 0 
            END,
        dying_and_iron_prod = dying_and_iron_prod - 
            CASE 
                WHEN OLD.section = 'dying_and_iron' THEN OLD.production_quantity 
                ELSE 0 
            END,
        -- teeth_coloring_prod = teeth_coloring_prod - 
        --     CASE 
        --         WHEN OLD.section = 'teeth_coloring' THEN OLD.production_quantity 
        --         ELSE 0 
        --     END,
        coloring_prod = coloring_prod - 
            CASE 
                WHEN OLD.section = 'coloring' THEN OLD.production_quantity
                ELSE 0 
            END
    FROM zipper.order_entry oe
    LEFT JOIN zipper.v_order_details_full vodf ON vodf.order_description_uuid = oe.order_description_uuid
    WHERE sfg.uuid = OLD.sfg_uuid AND sfg.order_entry_uuid = oe.uuid AND oe.order_description_uuid = od_uuid;

    RETURN OLD;
END;
$$;
 A   DROP FUNCTION zipper.sfg_after_sfg_production_delete_function();
       zipper          postgres    false    14            �           1255    304633 *   sfg_after_sfg_production_insert_function()    FUNCTION     �  CREATE FUNCTION zipper.sfg_after_sfg_production_insert_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
    item_name TEXT;
    od_uuid TEXT;
    nylon_stopper_name TEXT;
BEGIN
    -- Fetch item_name and order_description_uuid once
    SELECT vodf.item_name, oe.order_description_uuid, vodf.nylon_stopper_name INTO item_name, od_uuid, nylon_stopper_name
    FROM zipper.sfg sfg
    LEFT JOIN zipper.order_entry oe ON oe.uuid = sfg.order_entry_uuid
    LEFT JOIN zipper.v_order_details_full vodf ON oe.order_description_uuid = vodf.order_description_uuid
    WHERE sfg.uuid = NEW.sfg_uuid;

    -- Update order_description based on item_name
    IF lower(item_name) = 'metal' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred - 
                CASE 
                    WHEN NEW.section = 'teeth_molding' THEN NEW.production_quantity_in_kg + NEW.wastage 
                    ELSE 0
                END,
            slider_finishing_stock = slider_finishing_stock - 
                CASE 
                    WHEN NEW.section = 'finishing' THEN NEW.production_quantity
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;

    ELSIF lower(item_name) = 'vislon' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred - 
                CASE 
                    WHEN NEW.section = 'teeth_molding' THEN 
                        CASE
                            WHEN NEW.production_quantity_in_kg = 0 THEN NEW.production_quantity + NEW.wastage 
                            ELSE NEW.production_quantity_in_kg + NEW.wastage 
                        END
                    ELSE 0
                END,
            slider_finishing_stock = slider_finishing_stock -
                CASE 
                    WHEN NEW.section = 'finishing' THEN NEW.production_quantity 
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;

    ELSIF lower(item_name) = 'nylon' AND lower(nylon_stopper_name) = 'plastic' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred - 
                CASE 
                    WHEN NEW.section = 'finishing' THEN NEW.production_quantity_in_kg + NEW.wastage 
                    ELSE 
                        CASE
                            WHEN NEW.production_quantity_in_kg = 0 THEN NEW.production_quantity + NEW.wastage 
                            ELSE NEW.production_quantity_in_kg + NEW.wastage 
                        END 
                END,
            slider_finishing_stock = slider_finishing_stock -
                CASE 
                    WHEN NEW.section = 'finishing' THEN NEW.production_quantity
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;

    ELSIF lower(item_name) = 'nylon' AND lower(nylon_stopper_name) = 'metallic' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred - 
                CASE 
                    WHEN NEW.section = 'finishing' THEN NEW.production_quantity_in_kg + NEW.wastage 
                    ELSE 
                        CASE
                            WHEN NEW.production_quantity_in_kg = 0 THEN NEW.production_quantity + NEW.wastage 
                            ELSE NEW.production_quantity_in_kg + NEW.wastage 
                        END 
                END,
            slider_finishing_stock = slider_finishing_stock -
                CASE 
                    WHEN NEW.section = 'finishing' THEN NEW.production_quantity 
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;
    END IF;

    -- Update sfg table
    UPDATE zipper.sfg sfg
    SET 
        teeth_molding_prod = teeth_molding_prod + 
            CASE 
                WHEN NEW.section = 'teeth_molding' THEN 
                    CASE WHEN lower(vodf.item_name) = 'metal' 
                    THEN NEW.production_quantity 
                    ELSE 
                        CASE
                            WHEN NEW.production_quantity_in_kg = 0 THEN NEW.production_quantity 
                            ELSE NEW.production_quantity_in_kg 
                        END 
                    END
                ELSE 0
            END,
        finishing_stock = finishing_stock - 
            CASE 
                WHEN NEW.section = 'finishing' THEN 
                    CASE
                        WHEN NEW.production_quantity_in_kg = 0 THEN NEW.production_quantity + NEW.wastage 
                        ELSE NEW.production_quantity_in_kg + NEW.wastage 
                    END 
                ELSE 0
            END 
            + 
            CASE 
                WHEN NEW.section = 'teeth_coloring' THEN NEW.production_quantity 
                ELSE 0 
            END,
        finishing_prod = finishing_prod +
            CASE 
                WHEN NEW.section = 'finishing' THEN NEW.production_quantity 
                ELSE 0
            END,
        teeth_coloring_stock = teeth_coloring_stock - 
            CASE 
                WHEN NEW.section = 'teeth_coloring' THEN 
                    CASE 
                        WHEN NEW.production_quantity_in_kg = 0 THEN NEW.production_quantity + NEW.wastage 
                        ELSE NEW.production_quantity_in_kg + NEW.wastage 
                    END 
                ELSE 0 
            END,
        dying_and_iron_prod = dying_and_iron_prod + 
            CASE 
                WHEN NEW.section = 'dying_and_iron' THEN NEW.production_quantity 
                ELSE 0 
            END,
        -- teeth_coloring_prod = teeth_coloring_prod + 
        --     CASE 
        --         WHEN NEW.section = 'teeth_coloring' THEN NEW.production_quantity 
        --         ELSE 0 
        --     END,
        coloring_prod = coloring_prod + 
            CASE 
                WHEN NEW.section = 'coloring' THEN NEW.production_quantity
                ELSE 0 
            END
    FROM zipper.order_entry oe
    LEFT JOIN zipper.v_order_details_full vodf ON vodf.order_description_uuid = oe.order_description_uuid
    WHERE sfg.uuid = NEW.sfg_uuid AND sfg.order_entry_uuid = oe.uuid AND oe.order_description_uuid = od_uuid;

    RETURN NEW;
END;
$$;
 A   DROP FUNCTION zipper.sfg_after_sfg_production_insert_function();
       zipper          postgres    false    14            Z           1255    304634 *   sfg_after_sfg_production_update_function()    FUNCTION     D  CREATE FUNCTION zipper.sfg_after_sfg_production_update_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
    item_name TEXT;
    od_uuid TEXT;
    nylon_stopper_name TEXT;
BEGIN
    -- Fetch item_name and order_description_uuid once
    SELECT vodf.item_name, oe.order_description_uuid, vodf.nylon_stopper_name INTO item_name, od_uuid, nylon_stopper_name
    FROM zipper.sfg sfg
    LEFT JOIN zipper.order_entry oe ON oe.uuid = sfg.order_entry_uuid
    LEFT JOIN zipper.v_order_details_full vodf ON oe.order_description_uuid = vodf.order_description_uuid
    WHERE sfg.uuid = NEW.sfg_uuid;

    -- Update order_description based on item_name
    IF lower(item_name) = 'metal' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred - 
                CASE 
                    WHEN NEW.section = 'teeth_molding' THEN (NEW.production_quantity_in_kg + NEW.wastage) - (OLD.production_quantity_in_kg + OLD.wastage)
                    ELSE 0
                END,
            slider_finishing_stock = slider_finishing_stock - 
                CASE 
                    WHEN NEW.section = 'finishing' THEN (NEW.production_quantity) - (OLD.production_quantity)
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;

    ELSIF lower(item_name) = 'vislon' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred - 
                CASE 
                    WHEN NEW.section = 'teeth_molding' THEN 
                        CASE
                            WHEN NEW.production_quantity_in_kg = 0 THEN (NEW.production_quantity + NEW.wastage) - (OLD.production_quantity + OLD.wastage)
                            ELSE (NEW.production_quantity_in_kg + NEW.wastage) - (OLD.production_quantity_in_kg + OLD.wastage)
                        END
                    ELSE 0
                END,
            slider_finishing_stock = slider_finishing_stock - 
                CASE 
                    WHEN NEW.section = 'finishing' THEN (NEW.production_quantity) - (OLD.production_quantity)
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;

    ELSIF lower(item_name) = 'nylon' AND lower(nylon_stopper_name) = 'plastic' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred - 
                CASE 
                    WHEN NEW.section = 'finishing' THEN (NEW.production_quantity_in_kg + NEW.wastage) - (OLD.production_quantity_in_kg + OLD.wastage)
                    ELSE 
                        CASE
                            WHEN NEW.production_quantity_in_kg = 0 THEN (NEW.production_quantity + NEW.wastage) - (OLD.production_quantity + OLD.wastage)
                            ELSE (NEW.production_quantity_in_kg + NEW.wastage) - (OLD.production_quantity_in_kg + OLD.wastage)
                        END 
                END,
            slider_finishing_stock = slider_finishing_stock - 
                CASE 
                    WHEN NEW.section = 'finishing' THEN (NEW.production_quantity) - (OLD.production_quantity)
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;

    ELSIF lower(item_name) = 'nylon' AND lower(nylon_stopper_name) = 'metallic' THEN
        UPDATE zipper.order_description od
        SET 
            tape_transferred = tape_transferred - 
                CASE 
                    WHEN NEW.section = 'finishing' THEN (NEW.production_quantity_in_kg + NEW.wastage) - (OLD.production_quantity_in_kg + OLD.wastage)
                    ELSE 
                        CASE
                            WHEN NEW.production_quantity_in_kg = 0 THEN (NEW.production_quantity + NEW.wastage) - (OLD.production_quantity + OLD.wastage)
                            ELSE (NEW.production_quantity_in_kg + NEW.wastage) - (OLD.production_quantity_in_kg + OLD.wastage)
                        END 
                END,
            slider_finishing_stock = slider_finishing_stock - 
                CASE 
                    WHEN NEW.section = 'finishing' THEN (NEW.production_quantity) - (OLD.production_quantity)
                    ELSE 0
                END
        WHERE od.uuid = od_uuid;
    END IF;

    -- Update sfg table
    UPDATE zipper.sfg sfg
    SET 
        teeth_molding_prod = teeth_molding_prod + 
            CASE 
                WHEN NEW.section = 'teeth_molding' THEN 
                    CASE WHEN lower(vodf.item_name) = 'metal' 
                    THEN NEW.production_quantity - OLD.production_quantity 
                    ELSE
                        CASE
                            WHEN NEW.production_quantity_in_kg = 0 THEN NEW.production_quantity - OLD.production_quantity
                            ELSE NEW.production_quantity_in_kg - OLD.production_quantity_in_kg
                        END 
                    END
                ELSE 0
            END,
        finishing_stock = finishing_stock - 
            CASE 
                WHEN NEW.section = 'finishing' THEN 
                    CASE
                        WHEN NEW.production_quantity_in_kg = 0 THEN (NEW.production_quantity + NEW.wastage) - (OLD.production_quantity + OLD.wastage)
                        ELSE (NEW.production_quantity_in_kg + NEW.wastage) - (OLD.production_quantity_in_kg + OLD.wastage)
                    END 
                ELSE 0
            END 
            + 
            CASE 
                WHEN NEW.section = 'teeth_coloring' THEN NEW.production_quantity - OLD.production_quantity
                ELSE 0 
            END,
        finishing_prod = finishing_prod + 
            CASE 
                WHEN NEW.section = 'finishing' THEN NEW.production_quantity - OLD.production_quantity
                ELSE 0
            END,
        teeth_coloring_stock = teeth_coloring_stock - 
            CASE 
                WHEN NEW.section = 'teeth_coloring' THEN 
                    CASE 
                        WHEN NEW.production_quantity_in_kg = 0 THEN (NEW.production_quantity + NEW.wastage) - (OLD.production_quantity + OLD.wastage)
                        ELSE (NEW.production_quantity_in_kg + NEW.wastage) - (OLD.production_quantity_in_kg + OLD.wastage)
                    END 
                ELSE 0 
            END,
        dying_and_iron_prod = dying_and_iron_prod + 
            CASE 
                WHEN NEW.section = 'dying_and_iron' THEN NEW.production_quantity - OLD.production_quantity
                ELSE 0 
            END,
        -- teeth_coloring_prod = teeth_coloring_prod + 
        --     CASE 
        --         WHEN NEW.section = 'teeth_coloring' THEN NEW.production_quantity - OLD.production_quantity
        --         ELSE 0 
        --     END,
        coloring_prod = coloring_prod + 
            CASE 
                WHEN NEW.section = 'coloring' THEN NEW.production_quantity - OLD.production_quantity
                ELSE 0 
            END
    FROM zipper.order_entry oe
    LEFT JOIN zipper.v_order_details_full vodf ON vodf.order_description_uuid = oe.order_description_uuid
    WHERE sfg.uuid = NEW.sfg_uuid AND sfg.order_entry_uuid = oe.uuid AND oe.order_description_uuid = od_uuid;

    RETURN NEW;
END;
$$;
 A   DROP FUNCTION zipper.sfg_after_sfg_production_update_function();
       zipper          postgres    false    14            s           1255    304635 +   sfg_after_sfg_transaction_delete_function()    FUNCTION     (  CREATE FUNCTION zipper.sfg_after_sfg_transaction_delete_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    tocs_uuid INT;
BEGIN
    -- Updating stocks based on OLD.trx_to
    UPDATE zipper.sfg
     SET
        teeth_molding_stock = teeth_molding_stock 
            - CASE WHEN OLD.trx_to = 'teeth_molding_stock' THEN 
            CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END,
        teeth_coloring_stock = teeth_coloring_stock 
            - CASE WHEN OLD.trx_to = 'teeth_coloring_stock' THEN 
            CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END,
        finishing_stock = finishing_stock 
            - CASE WHEN OLD.trx_to = 'finishing_stock' THEN 
            CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END,
        warehouse = warehouse 
            - CASE WHEN OLD.trx_to = 'warehouse' THEN 
            CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END
    WHERE uuid = OLD.sfg_uuid;

    -- Updating productions based on OLD.trx_from
    UPDATE zipper.sfg SET
        teeth_molding_prod = teeth_molding_prod + 
        CASE WHEN OLD.trx_from = 'teeth_molding_prod' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END,

        teeth_coloring_prod = teeth_coloring_prod + 
        CASE WHEN OLD.trx_from = 'teeth_coloring_prod' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END,

        finishing_prod = finishing_prod + 
        CASE WHEN OLD.trx_from = 'finishing_prod' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END,

        warehouse = warehouse + 
        CASE WHEN OLD.trx_from = 'warehouse' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END
    WHERE uuid = OLD.sfg_uuid;

    RETURN OLD;
END;
$$;
 B   DROP FUNCTION zipper.sfg_after_sfg_transaction_delete_function();
       zipper          postgres    false    14            �           1255    304636 +   sfg_after_sfg_transaction_insert_function()    FUNCTION     *  CREATE FUNCTION zipper.sfg_after_sfg_transaction_insert_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    tocs_uuid INT;
BEGIN
    -- Updating stocks based on NEW.trx_to
    UPDATE zipper.sfg SET
        teeth_molding_stock = teeth_molding_stock + 
        CASE WHEN NEW.trx_to = 'teeth_molding_stock' THEN 
        CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,

        teeth_coloring_stock = teeth_coloring_stock + 
        CASE WHEN NEW.trx_to = 'teeth_coloring_stock' THEN 
        CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,

        finishing_stock = finishing_stock + 
        CASE WHEN NEW.trx_to = 'finishing_stock' THEN 
        CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,

        warehouse = warehouse + 
        CASE WHEN NEW.trx_to = 'warehouse' THEN 
        CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END
    WHERE uuid = NEW.sfg_uuid;

    -- Updating productions based on NEW.trx_from
    UPDATE zipper.sfg SET
        teeth_molding_prod = teeth_molding_prod - 
        CASE WHEN NEW.trx_from = 'teeth_molding_prod' THEN 
        CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,

        teeth_coloring_prod = teeth_coloring_prod - 
        CASE WHEN NEW.trx_from = 'teeth_coloring_prod' THEN 
        CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,

        finishing_prod = finishing_prod - 
        CASE WHEN NEW.trx_from = 'finishing_prod' THEN 
        CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,

        warehouse = warehouse - 
        CASE WHEN NEW.trx_from = 'warehouse' THEN 
        CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END
    WHERE uuid = NEW.sfg_uuid;

    RETURN NEW;
END;
$$;
 B   DROP FUNCTION zipper.sfg_after_sfg_transaction_insert_function();
       zipper          postgres    false    14            d           1255    304637 +   sfg_after_sfg_transaction_update_function()    FUNCTION     ?  CREATE FUNCTION zipper.sfg_after_sfg_transaction_update_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    tocs_uuid INT;
BEGIN
    -- Updating stocks based on OLD.trx_to and NEW.trx_to
    UPDATE zipper.sfg SET
        teeth_molding_stock = teeth_molding_stock 
            - CASE WHEN OLD.trx_to = 'teeth_molding_stock' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END
            + CASE WHEN NEW.trx_to = 'teeth_molding_stock' THEN CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,
        teeth_coloring_stock = teeth_coloring_stock 
            - CASE WHEN OLD.trx_to = 'teeth_coloring_stock' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END
            + CASE WHEN NEW.trx_to = 'teeth_coloring_stock' THEN CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,
        finishing_stock = finishing_stock 
            - CASE WHEN OLD.trx_to = 'finishing_stock' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END
            + CASE WHEN NEW.trx_to = 'finishing_stock' THEN CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,
        warehouse = warehouse 
            - CASE WHEN OLD.trx_to = 'warehouse' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END
            + CASE WHEN NEW.trx_to = 'warehouse' THEN CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END
    WHERE uuid = NEW.sfg_uuid;

    -- Updating productions based on OLD.trx_from and NEW.trx_from
    UPDATE zipper.sfg SET
        teeth_molding_prod = teeth_molding_prod 
            + CASE WHEN OLD.trx_from = 'teeth_molding_prod' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END
            - CASE WHEN NEW.trx_from = 'teeth_molding_prod' THEN CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,
        teeth_coloring_prod = teeth_coloring_prod 
            + CASE WHEN OLD.trx_from = 'teeth_coloring_prod' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END
            - CASE WHEN NEW.trx_from = 'teeth_coloring_prod' THEN CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,
        finishing_prod = finishing_prod 
            + CASE WHEN OLD.trx_from = 'finishing_prod' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END
            - CASE WHEN NEW.trx_from = 'finishing_prod' THEN CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END,
        warehouse = warehouse 
            + CASE WHEN OLD.trx_from = 'warehouse' THEN CASE WHEN OLD.trx_quantity_in_kg = 0 THEN OLD.trx_quantity ELSE OLD.trx_quantity_in_kg END ELSE 0 END
            - CASE WHEN NEW.trx_from = 'warehouse' THEN CASE WHEN NEW.trx_quantity_in_kg = 0 THEN NEW.trx_quantity ELSE NEW.trx_quantity_in_kg END ELSE 0 END
        WHERE uuid = NEW.sfg_uuid;
    
    RETURN NEW;
END;
$$;
 B   DROP FUNCTION zipper.sfg_after_sfg_transaction_update_function();
       zipper          postgres    false    14            g           1255    304638 A   stock_after_material_trx_against_order_description_delete_funct()    FUNCTION     =  CREATE FUNCTION zipper.stock_after_material_trx_against_order_description_delete_funct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update material,stock
    UPDATE material.stock
    SET
        stock = stock + OLD.trx_quantity
    WHERE material_uuid = OLD.material_uuid;

    RETURN OLD;
END;
$$;
 X   DROP FUNCTION zipper.stock_after_material_trx_against_order_description_delete_funct();
       zipper          postgres    false    14            U           1255    304639 A   stock_after_material_trx_against_order_description_insert_funct()    FUNCTION     =  CREATE FUNCTION zipper.stock_after_material_trx_against_order_description_insert_funct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update material,stock
    UPDATE material.stock
    SET
        stock = stock - NEW.trx_quantity
    WHERE material_uuid = NEW.material_uuid;

    RETURN NEW;
END;
$$;
 X   DROP FUNCTION zipper.stock_after_material_trx_against_order_description_insert_funct();
       zipper          postgres    false    14            �           1255    304640 A   stock_after_material_trx_against_order_description_update_funct()    FUNCTION     i  CREATE FUNCTION zipper.stock_after_material_trx_against_order_description_update_funct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update material,stock
    UPDATE material.stock
    SET
        stock = stock 
            - NEW.trx_quantity
            + OLD.trx_quantity
    WHERE material_uuid = NEW.material_uuid;

    RETURN NEW;
END;
$$;
 X   DROP FUNCTION zipper.stock_after_material_trx_against_order_description_update_funct();
       zipper          postgres    false    14            �           1255    304641 &   tape_coil_after_tape_coil_production()    FUNCTION     �  CREATE FUNCTION zipper.tape_coil_after_tape_coil_production() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    --Update zipper.tape_coil table
    UPDATE zipper.tape_coil 
    SET
        -- Tape Production
        quantity = quantity 
        + CASE WHEN NEW.section = 'tape' THEN NEW.production_quantity ELSE 0 END,

        -- Coil Production
        trx_quantity_in_coil = trx_quantity_in_coil 
        - CASE WHEN NEW.section = 'coil' THEN NEW.production_quantity + NEW.wastage ELSE 0 END,
        quantity_in_coil = quantity_in_coil
        + CASE WHEN NEW.section = 'coil' THEN NEW.production_quantity ELSE 0 END,

        -- Tape Or Production for Stock
        trx_quantity_in_dying = trx_quantity_in_dying
        - CASE WHEN NEW.section = 'stock' THEN NEW.production_quantity + NEW.wastage ELSE 0 END,
        stock_quantity = stock_quantity 
        + CASE WHEN NEW.section = 'stock' THEN NEW.production_quantity ELSE 0 END

    WHERE uuid = NEW.tape_coil_uuid;

    RETURN NEW;
END;
$$;
 =   DROP FUNCTION zipper.tape_coil_after_tape_coil_production();
       zipper          postgres    false    14            �           1255    304642 -   tape_coil_after_tape_coil_production_delete()    FUNCTION     �  CREATE FUNCTION zipper.tape_coil_after_tape_coil_production_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update zipper.tape_coil table
    UPDATE zipper.tape_coil 
    SET
        -- Tape Production
        quantity = quantity 
        - CASE WHEN OLD.section = 'tape' THEN OLD.production_quantity ELSE 0 END,

        -- Coil Production
        trx_quantity_in_coil = trx_quantity_in_coil 
        + CASE WHEN OLD.section = 'coil' THEN OLD.production_quantity + OLD.wastage ELSE 0 END,
        quantity_in_coil = quantity_in_coil
        - CASE WHEN OLD.section = 'coil' THEN OLD.production_quantity ELSE 0 END,

        -- Tape Or Production for Stock
        trx_quantity_in_dying = trx_quantity_in_dying
        + CASE WHEN OLD.section = 'stock' THEN OLD.production_quantity  + OLD.wastage ELSE 0 END,
        stock_quantity = stock_quantity 
        - CASE WHEN OLD.section = 'stock' THEN OLD.production_quantity ELSE 0 END

    WHERE uuid = OLD.tape_coil_uuid;

    RETURN OLD;
END;
$$;
 D   DROP FUNCTION zipper.tape_coil_after_tape_coil_production_delete();
       zipper          postgres    false    14            r           1255    304643 -   tape_coil_after_tape_coil_production_update()    FUNCTION     �  CREATE FUNCTION zipper.tape_coil_after_tape_coil_production_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update zipper.tape_coil table
    UPDATE zipper.tape_coil 
    SET
        -- Tape Production
        quantity = quantity 
        + CASE WHEN OLD.section = 'tape' THEN OLD.production_quantity ELSE 0 END
        - CASE WHEN NEW.section = 'tape' THEN NEW.production_quantity ELSE 0 END,

        -- Coil Production
        trx_quantity_in_coil = trx_quantity_in_coil 
        + CASE WHEN OLD.section = 'coil' THEN OLD.production_quantity + OLD.wastage ELSE 0 END
        - CASE WHEN NEW.section = 'coil' THEN NEW.production_quantity + NEW.wastage ELSE 0 END,

        quantity_in_coil = quantity_in_coil
        - CASE WHEN OLD.section = 'coil' THEN OLD.production_quantity ELSE 0 END
        + CASE WHEN NEW.section = 'coil' THEN NEW.production_quantity ELSE 0 END,

        -- Tape Or Production for Stock
        trx_quantity_in_dying = trx_quantity_in_dying
        + CASE WHEN OLD.section = 'stock' THEN OLD.production_quantity + OLD.wastage ELSE 0 END
        - CASE WHEN NEW.section = 'stock' THEN NEW.production_quantity + NEW.wastage ELSE 0 END,

        stock_quantity = stock_quantity 
        - CASE WHEN OLD.section = 'stock' THEN OLD.production_quantity ELSE 0 END
        + CASE WHEN NEW.section = 'stock' THEN NEW.production_quantity ELSE 0 END

    WHERE uuid = NEW.tape_coil_uuid;

    RETURN NEW;
END;
$$;
 D   DROP FUNCTION zipper.tape_coil_after_tape_coil_production_update();
       zipper          postgres    false    14            �           1255    304644 !   tape_coil_after_tape_trx_delete()    FUNCTION     �  CREATE FUNCTION zipper.tape_coil_after_tape_trx_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update zipper.tape_coil table
    UPDATE zipper.tape_coil 
    SET
        -- Tape Trx to Coil Or Dyeing
        quantity = quantity + CASE WHEN OLD.to_section = 'dyeing' OR OLD.to_section = 'coil' THEN OLD.trx_quantity ELSE 0 END,
        -- Coil To Dyeing
        quantity_in_coil = quantity_in_coil + CASE WHEN OLD.to_section = 'coil_dyeing' AND (SELECT lower(name) FROM public.properties WHERE zipper.tape_coil.item_uuid = public.properties.uuid) = 'nylon' THEN OLD.trx_quantity ELSE 0 END,
        -- Tape AND Coil Dyeing Trx
        trx_quantity_in_dying = trx_quantity_in_dying 
        - CASE WHEN OLD.to_section = 'dyeing' OR OLD.to_section = 'coil_dyeing' THEN OLD.trx_quantity ELSE 0 END
        + CASE WHEN OLD.to_section = 'stock' THEN OLD.trx_quantity ELSE 0 END,
        -- Tape to Coil Trx 
        trx_quantity_in_coil = trx_quantity_in_coil - CASE WHEN OLD.to_section = 'coil' THEN OLD.trx_quantity ELSE 0 END,
        -- Dyed Tape or Coil Stock
        stock_quantity = stock_quantity - CASE WHEN OLD.to_section = 'stock' THEN OLD.trx_quantity ELSE 0 END
    WHERE uuid = OLD.tape_coil_uuid;
    RETURN OLD;
END;
$$;
 8   DROP FUNCTION zipper.tape_coil_after_tape_trx_delete();
       zipper          postgres    false    14            G           1255    304645 !   tape_coil_after_tape_trx_insert()    FUNCTION     �  CREATE FUNCTION zipper.tape_coil_after_tape_trx_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    --Update zipper.tape_coil table
    UPDATE zipper.tape_coil 
    SET
        -- Tape Trx to Coil Or Dyeing
        quantity = quantity - CASE WHEN NEW.to_section = 'dyeing' OR NEW.to_section = 'coil' THEN NEW.trx_quantity ELSE 0 END,
        -- Coil To Dyeing
        quantity_in_coil = quantity_in_coil 
        - CASE WHEN NEW.to_section = 'coil_dyeing' AND (SELECT lower(name) FROM public.properties where zipper.tape_coil.item_uuid = public.properties.uuid) = 'nylon' THEN NEW.trx_quantity ELSE 0 END,
        -- Tape AND Coil Dyeing Trx
        trx_quantity_in_dying = trx_quantity_in_dying 
        + CASE WHEN NEW.to_section = 'dyeing' OR NEW.to_section = 'coil_dyeing' THEN NEW.trx_quantity ELSE 0 END 
        - CASE WHEN NEW.to_section = 'stock' THEN NEW.trx_quantity ELSE 0 END,
        
        -- Tape to Coil Trx 
        trx_quantity_in_coil = trx_quantity_in_coil + CASE WHEN NEW.to_section = 'coil' THEN NEW.trx_quantity ELSE 0 END,

        -- Dyed Tape or Coil Stock
        stock_quantity = stock_quantity + CASE WHEN NEW.to_section = 'stock' THEN NEW.trx_quantity ELSE 0 END

    WHERE uuid = NEW.tape_coil_uuid;
RETURN NEW;
END;
$$;
 8   DROP FUNCTION zipper.tape_coil_after_tape_trx_insert();
       zipper          postgres    false    14            b           1255    304646 !   tape_coil_after_tape_trx_update()    FUNCTION     �  CREATE FUNCTION zipper.tape_coil_after_tape_trx_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update zipper.tape_coil table
    UPDATE zipper.tape_coil 
    SET
        -- Tape Trx to Coil Or Dyeing
        quantity = quantity - CASE 
            WHEN NEW.to_section = 'dyeing' OR NEW.to_section = 'coil' THEN NEW.trx_quantity 
            ELSE 0 
        END + CASE 
            WHEN OLD.to_section = 'dyeing' OR OLD.to_section = 'coil' THEN OLD.trx_quantity 
            ELSE 0 
        END,
        -- Coil To Dyeing
        quantity_in_coil = quantity_in_coil - CASE 
            WHEN NEW.to_section = 'coil_dyeing' AND (SELECT lower(name) FROM public.properties WHERE zipper.tape_coil.item_uuid = public.properties.uuid) = 'nylon' THEN NEW.trx_quantity 
            ELSE 0 
        END + CASE 
            WHEN OLD.to_section = 'coil_dyeing' AND (SELECT lower(name) FROM public.properties WHERE zipper.tape_coil.item_uuid = public.properties.uuid) = 'nylon' THEN OLD.trx_quantity 
            ELSE 0 
        END,
        -- Tape AND Coil Dyeing Trx
        trx_quantity_in_dying = trx_quantity_in_dying + CASE 
            WHEN NEW.to_section = 'dyeing' OR NEW.to_section = 'coil_dyeing' THEN NEW.trx_quantity 
            ELSE 0 
        END - CASE 
            WHEN OLD.to_section = 'dyeing' OR OLD.to_section = 'coil_dyeing' THEN OLD.trx_quantity 
            ELSE 0 
        END
        - CASE 
            WHEN NEW.to_section = 'stock' THEN NEW.trx_quantity 
            ELSE 0 
        END + CASE 
            WHEN OLD.to_section = 'stock' THEN OLD.trx_quantity 
            ELSE 0 
        END,
        -- Tape to Coil Trx 
        trx_quantity_in_coil = trx_quantity_in_coil + CASE 
            WHEN NEW.to_section = 'coil' THEN NEW.trx_quantity 
            ELSE 0 
        END - CASE 
            WHEN OLD.to_section = 'coil' THEN OLD.trx_quantity 
            ELSE 0 
        END,
        -- Dyed Tape or Coil Stock
        stock_quantity = stock_quantity + CASE 
            WHEN NEW.to_section = 'stock' THEN NEW.trx_quantity 
            ELSE 0 
        END - CASE 
            WHEN OLD.to_section = 'stock' THEN OLD.trx_quantity 
            ELSE 0 
        END
    WHERE uuid = NEW.tape_coil_uuid;
    RETURN NEW;
END;
$$;
 8   DROP FUNCTION zipper.tape_coil_after_tape_trx_update();
       zipper          postgres    false    14            �           1255    304647 A   tape_coil_and_order_description_after_dyed_tape_transaction_del()    FUNCTION       CREATE FUNCTION zipper.tape_coil_and_order_description_after_dyed_tape_transaction_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
    -- Update zipper.tape_coil
    UPDATE zipper.tape_coil
    SET
        stock_quantity = stock_quantity + OLD.trx_quantity
    WHERE uuid = OLD.tape_coil_uuid;
    -- Update zipper.order_description
    UPDATE zipper.order_description
    SET
        tape_transferred = tape_transferred - OLD.trx_quantity
    WHERE uuid = OLD.order_description_uuid;

    RETURN OLD;
END;

$$;
 X   DROP FUNCTION zipper.tape_coil_and_order_description_after_dyed_tape_transaction_del();
       zipper          postgres    false    14            ^           1255    304648 A   tape_coil_and_order_description_after_dyed_tape_transaction_ins()    FUNCTION       CREATE FUNCTION zipper.tape_coil_and_order_description_after_dyed_tape_transaction_ins() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update zipper.tape_coil
    UPDATE zipper.tape_coil
    SET
        stock_quantity = stock_quantity - NEW.trx_quantity
    WHERE uuid = NEW.tape_coil_uuid;
    -- Update zipper.order_description
    UPDATE zipper.order_description
    SET
        tape_transferred = tape_transferred + NEW.trx_quantity
    WHERE uuid = NEW.order_description_uuid;

    RETURN NEW;
END;

$$;
 X   DROP FUNCTION zipper.tape_coil_and_order_description_after_dyed_tape_transaction_ins();
       zipper          postgres    false    14            k           1255    304649 A   tape_coil_and_order_description_after_dyed_tape_transaction_upd()    FUNCTION     2  CREATE FUNCTION zipper.tape_coil_and_order_description_after_dyed_tape_transaction_upd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
    -- Update zipper.tape_coil
    UPDATE zipper.tape_coil
    SET
        stock_quantity = stock_quantity - NEW.trx_quantity + OLD.trx_quantity
    WHERE uuid = NEW.tape_coil_uuid;
    -- Update zipper.order_description
    UPDATE zipper.order_description
    SET
        tape_transferred = tape_transferred + NEW.trx_quantity - OLD.trx_quantity
    WHERE uuid = NEW.order_description_uuid;

    RETURN NEW;
END;

$$;
 X   DROP FUNCTION zipper.tape_coil_and_order_description_after_dyed_tape_transaction_upd();
       zipper          postgres    false    14            �            1259    304650    bank    TABLE     /  CREATE TABLE commercial.bank (
    uuid text NOT NULL,
    name text NOT NULL,
    swift_code text NOT NULL,
    address text,
    policy text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    created_by text,
    routing_no text
);
    DROP TABLE commercial.bank;
    
   commercial         heap    postgres    false    5            �            1259    304655    lc_sequence    SEQUENCE     x   CREATE SEQUENCE commercial.lc_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE commercial.lc_sequence;
    
   commercial          postgres    false    5            �            1259    304656    lc    TABLE     �  CREATE TABLE commercial.lc (
    uuid text NOT NULL,
    party_uuid text,
    lc_number text NOT NULL,
    lc_date timestamp without time zone NOT NULL,
    payment_date timestamp without time zone,
    ldbc_fdbc text,
    acceptance_date timestamp without time zone,
    maturity_date timestamp without time zone,
    commercial_executive text NOT NULL,
    party_bank text NOT NULL,
    production_complete integer DEFAULT 0,
    lc_cancel integer DEFAULT 0,
    handover_date timestamp without time zone,
    shipment_date timestamp without time zone,
    expiry_date timestamp without time zone,
    ud_no text,
    ud_received text,
    at_sight text,
    amd_date timestamp without time zone,
    amd_count integer DEFAULT 0,
    problematical integer DEFAULT 0,
    epz integer DEFAULT 0,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    id integer DEFAULT nextval('commercial.lc_sequence'::regclass) NOT NULL,
    document_receive_date timestamp without time zone,
    is_rtgs integer DEFAULT 0,
    lc_value numeric(20,4) DEFAULT 0 NOT NULL,
    is_old_pi integer DEFAULT 0,
    pi_number text,
    payment_value numeric(20,4) DEFAULT 0 NOT NULL
);
    DROP TABLE commercial.lc;
    
   commercial         heap    postgres    false    226    5            �            1259    304671    pi_sequence    SEQUENCE     x   CREATE SEQUENCE commercial.pi_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE commercial.pi_sequence;
    
   commercial          postgres    false    5            �            1259    304672    pi_cash    TABLE     �  CREATE TABLE commercial.pi_cash (
    uuid text NOT NULL,
    id integer DEFAULT nextval('commercial.pi_sequence'::regclass) NOT NULL,
    lc_uuid text,
    order_info_uuids text NOT NULL,
    marketing_uuid text,
    party_uuid text,
    merchandiser_uuid text,
    factory_uuid text,
    bank_uuid text,
    validity integer DEFAULT 0,
    payment integer DEFAULT 0,
    is_pi integer DEFAULT 0,
    conversion_rate numeric(20,4) DEFAULT 0,
    receive_amount numeric(20,4) DEFAULT 0,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    weight numeric(20,4) DEFAULT 0 NOT NULL,
    thread_order_info_uuids text
);
    DROP TABLE commercial.pi_cash;
    
   commercial         heap    postgres    false    228    5            �            1259    304684    pi_cash_entry    TABLE     .  CREATE TABLE commercial.pi_cash_entry (
    uuid text NOT NULL,
    pi_cash_uuid text,
    sfg_uuid text,
    pi_cash_quantity numeric(20,4) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    thread_order_entry_uuid text
);
 %   DROP TABLE commercial.pi_cash_entry;
    
   commercial         heap    postgres    false    5            �            1259    304689    challan_sequence    SEQUENCE     {   CREATE SEQUENCE delivery.challan_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE delivery.challan_sequence;
       delivery          postgres    false    6            �            1259    304690    challan    TABLE     �  CREATE TABLE delivery.challan (
    uuid text NOT NULL,
    carton_quantity integer NOT NULL,
    assign_to text,
    receive_status integer DEFAULT 0,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    id integer DEFAULT nextval('delivery.challan_sequence'::regclass),
    gate_pass integer DEFAULT 0,
    order_info_uuid text
);
    DROP TABLE delivery.challan;
       delivery         heap    postgres    false    231    6            �            1259    304698    challan_entry    TABLE     �   CREATE TABLE delivery.challan_entry (
    uuid text NOT NULL,
    challan_uuid text,
    packing_list_uuid text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 #   DROP TABLE delivery.challan_entry;
       delivery         heap    postgres    false    6            �            1259    304703    packing_list_sequence    SEQUENCE     �   CREATE SEQUENCE delivery.packing_list_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE delivery.packing_list_sequence;
       delivery          postgres    false    6            �            1259    304704    packing_list    TABLE     �  CREATE TABLE delivery.packing_list (
    uuid text NOT NULL,
    carton_size text NOT NULL,
    carton_weight text NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    order_info_uuid text,
    id integer DEFAULT nextval('delivery.packing_list_sequence'::regclass),
    challan_uuid text
);
 "   DROP TABLE delivery.packing_list;
       delivery         heap    postgres    false    234    6            �            1259    304710    packing_list_entry    TABLE     Y  CREATE TABLE delivery.packing_list_entry (
    uuid text NOT NULL,
    packing_list_uuid text,
    sfg_uuid text,
    quantity numeric(20,4) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    short_quantity integer DEFAULT 0,
    reject_quantity integer DEFAULT 0
);
 (   DROP TABLE delivery.packing_list_entry;
       delivery         heap    postgres    false    6            �            1259    304717    users    TABLE     C  CREATE TABLE hr.users (
    uuid text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    pass text NOT NULL,
    designation_uuid text,
    can_access text,
    ext text,
    phone text,
    created_at text NOT NULL,
    updated_at text,
    status text DEFAULT 0,
    remarks text,
    department_uuid text
);
    DROP TABLE hr.users;
       hr         heap    postgres    false    8            �            1259    304723    buyer    TABLE     �   CREATE TABLE public.buyer (
    uuid text NOT NULL,
    name text NOT NULL,
    short_name text,
    remarks text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    created_by text
);
    DROP TABLE public.buyer;
       public         heap    postgres    false    15            �            1259    304728    factory    TABLE       CREATE TABLE public.factory (
    uuid text NOT NULL,
    party_uuid text,
    name text NOT NULL,
    phone text,
    address text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    created_by text,
    remarks text
);
    DROP TABLE public.factory;
       public         heap    postgres    false    15            �            1259    304733 	   marketing    TABLE       CREATE TABLE public.marketing (
    uuid text NOT NULL,
    name text NOT NULL,
    short_name text,
    user_uuid text,
    remarks text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    created_by text
);
    DROP TABLE public.marketing;
       public         heap    postgres    false    15            �            1259    304738    merchandiser    TABLE     $  CREATE TABLE public.merchandiser (
    uuid text NOT NULL,
    party_uuid text,
    name text NOT NULL,
    email text,
    phone text,
    address text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    created_by text,
    remarks text
);
     DROP TABLE public.merchandiser;
       public         heap    postgres    false    15            �            1259    304743    party    TABLE       CREATE TABLE public.party (
    uuid text NOT NULL,
    name text NOT NULL,
    short_name text NOT NULL,
    remarks text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    created_by text,
    address text
);
    DROP TABLE public.party;
       public         heap    postgres    false    15            �            1259    304748 
   properties    TABLE     -  CREATE TABLE public.properties (
    uuid text NOT NULL,
    item_for text NOT NULL,
    type text NOT NULL,
    name text NOT NULL,
    short_name text NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
    DROP TABLE public.properties;
       public         heap    postgres    false    15            �            1259    304753    stock    TABLE     a  CREATE TABLE slider.stock (
    uuid text NOT NULL,
    order_quantity numeric(20,4) DEFAULT 0,
    body_quantity numeric(20,4) DEFAULT 0,
    cap_quantity numeric(20,4) DEFAULT 0,
    puller_quantity numeric(20,4) DEFAULT 0,
    link_quantity numeric(20,4) DEFAULT 0,
    sa_prod numeric(20,4) DEFAULT 0,
    coloring_stock numeric(20,4) DEFAULT 0,
    coloring_prod numeric(20,4) DEFAULT 0,
    trx_to_finishing numeric(20,4) DEFAULT 0,
    u_top_quantity numeric(20,4) DEFAULT 0,
    h_bottom_quantity numeric(20,4) DEFAULT 0,
    box_pin_quantity numeric(20,4) DEFAULT 0,
    two_way_pin_quantity numeric(20,4) DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    quantity_in_sa numeric(20,4) DEFAULT 0,
    order_description_uuid text,
    finishing_stock numeric(20,4) DEFAULT 0
);
    DROP TABLE slider.stock;
       slider         heap    postgres    false    12            �            1259    304773    order_description    TABLE     z  CREATE TABLE zipper.order_description (
    uuid text NOT NULL,
    order_info_uuid text,
    item text,
    zipper_number text,
    end_type text,
    lock_type text,
    puller_type text,
    teeth_color text,
    puller_color text,
    special_requirement text,
    hand text,
    coloring_type text,
    is_slider_provided integer DEFAULT 0,
    slider text,
    slider_starting_section_enum zipper.slider_starting_section_enum,
    top_stopper text,
    bottom_stopper text,
    logo_type text,
    is_logo_body integer DEFAULT 0 NOT NULL,
    is_logo_puller integer DEFAULT 0 NOT NULL,
    description text,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    slider_body_shape text,
    slider_link text,
    end_user text,
    garment text,
    light_preference text,
    garments_wash text,
    created_by text,
    garments_remarks text,
    tape_received numeric(20,4) DEFAULT 0 NOT NULL,
    tape_transferred numeric(20,4) DEFAULT 0 NOT NULL,
    slider_finishing_stock numeric(20,4) DEFAULT 0 NOT NULL,
    nylon_stopper text,
    tape_coil_uuid text,
    teeth_type text,
    is_inch integer DEFAULT 0,
    order_type zipper.order_type_enum DEFAULT 'full'::zipper.order_type_enum,
    is_meter integer DEFAULT 0,
    is_cm integer DEFAULT 0,
    is_multi_color integer DEFAULT 0
);
 %   DROP TABLE zipper.order_description;
       zipper         heap    postgres    false    1051    1051    1057    14            �            1259    304790    order_entry    TABLE     y  CREATE TABLE zipper.order_entry (
    uuid text NOT NULL,
    order_description_uuid text,
    style text NOT NULL,
    color text,
    size text,
    quantity numeric(20,4) NOT NULL,
    company_price numeric(20,4) DEFAULT 0 NOT NULL,
    party_price numeric(20,4) DEFAULT 0 NOT NULL,
    status integer DEFAULT 1,
    swatch_status_enum zipper.swatch_status_enum DEFAULT 'pending'::zipper.swatch_status_enum,
    swatch_approval_date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    bleaching text,
    is_inch integer DEFAULT 0
);
    DROP TABLE zipper.order_entry;
       zipper         heap    postgres    false    1060    1060    14            �            1259    304800    order_info_sequence    SEQUENCE     |   CREATE SEQUENCE zipper.order_info_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE zipper.order_info_sequence;
       zipper          postgres    false    14            �            1259    304801 
   order_info    TABLE     �  CREATE TABLE zipper.order_info (
    uuid text NOT NULL,
    id integer DEFAULT nextval('zipper.order_info_sequence'::regclass) NOT NULL,
    reference_order_info_uuid text,
    buyer_uuid text,
    party_uuid text,
    marketing_uuid text,
    merchandiser_uuid text,
    factory_uuid text,
    is_sample integer DEFAULT 0,
    is_bill integer DEFAULT 0,
    is_cash integer DEFAULT 0,
    marketing_priority text,
    factory_priority text,
    status integer DEFAULT 0 NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    conversion_rate numeric(20,4) DEFAULT 0 NOT NULL,
    print_in zipper.print_in_enum DEFAULT 'portrait'::zipper.print_in_enum
);
    DROP TABLE zipper.order_info;
       zipper         heap    postgres    false    247    1054    14    1054            �            1259    304813    sfg    TABLE     �  CREATE TABLE zipper.sfg (
    uuid text NOT NULL,
    order_entry_uuid text,
    recipe_uuid text,
    dying_and_iron_prod numeric(20,4) DEFAULT 0,
    teeth_molding_stock numeric(20,4) DEFAULT 0,
    teeth_molding_prod numeric(20,4) DEFAULT 0,
    teeth_coloring_stock numeric(20,4) DEFAULT 0,
    teeth_coloring_prod numeric(20,4) DEFAULT 0,
    finishing_stock numeric(20,4) DEFAULT 0,
    finishing_prod numeric(20,4) DEFAULT 0,
    coloring_prod numeric(20,4) DEFAULT 0,
    warehouse numeric(20,4) DEFAULT 0 NOT NULL,
    delivered numeric(20,4) DEFAULT 0 NOT NULL,
    pi numeric(20,4) DEFAULT 0 NOT NULL,
    remarks text,
    short_quantity integer DEFAULT 0,
    reject_quantity integer DEFAULT 0
);
    DROP TABLE zipper.sfg;
       zipper         heap    postgres    false    14            �            1259    304831 	   tape_coil    TABLE     �  CREATE TABLE zipper.tape_coil (
    uuid text NOT NULL,
    quantity numeric(20,4) DEFAULT 0 NOT NULL,
    trx_quantity_in_coil numeric(20,4) DEFAULT 0 NOT NULL,
    quantity_in_coil numeric(20,4) DEFAULT 0 NOT NULL,
    remarks text,
    item_uuid text,
    zipper_number_uuid text,
    name text NOT NULL,
    raw_per_kg_meter numeric(20,4) DEFAULT 0 NOT NULL,
    dyed_per_kg_meter numeric(20,4) DEFAULT 0 NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    is_import text,
    is_reverse text,
    trx_quantity_in_dying numeric(20,4) DEFAULT 0 NOT NULL,
    stock_quantity numeric(20,4) DEFAULT 0 NOT NULL
);
    DROP TABLE zipper.tape_coil;
       zipper         heap    postgres    false    14            �            1259    304843    v_order_details_full    VIEW     �  CREATE VIEW zipper.v_order_details_full AS
 SELECT order_info.uuid AS order_info_uuid,
    concat('Z', to_char(order_info.created_at, 'YY'::text), '-', lpad((order_info.id)::text, 4, '0'::text)) AS order_number,
    order_description.uuid AS order_description_uuid,
    (order_description.tape_received)::double precision AS tape_received,
    (order_description.tape_transferred)::double precision AS tape_transferred,
    (order_description.slider_finishing_stock)::double precision AS slider_finishing_stock,
    order_info.marketing_uuid,
    marketing.name AS marketing_name,
    order_info.buyer_uuid,
    buyer.name AS buyer_name,
    order_info.merchandiser_uuid,
    merchandiser.name AS merchandiser_name,
    order_info.factory_uuid,
    factory.name AS factory_name,
    factory.address AS factory_address,
    order_info.party_uuid,
    party.name AS party_name,
    order_info.created_by AS created_by_uuid,
    users.name AS created_by_name,
    order_info.is_cash,
    order_info.is_bill,
    order_info.is_sample,
    order_info.status AS order_status,
    order_info.created_at,
    order_info.updated_at,
    order_info.print_in,
    concat(op_item.short_name, op_nylon_stopper.short_name, '-', op_zipper.short_name, '-', op_end.short_name, '-', op_puller.short_name) AS item_description,
    order_description.item,
    op_item.name AS item_name,
    op_item.short_name AS item_short_name,
    order_description.nylon_stopper,
    op_nylon_stopper.name AS nylon_stopper_name,
    op_nylon_stopper.short_name AS nylon_stopper_short_name,
    order_description.zipper_number,
    op_zipper.name AS zipper_number_name,
    op_zipper.short_name AS zipper_number_short_name,
    order_description.end_type,
    op_end.name AS end_type_name,
    op_end.short_name AS end_type_short_name,
    order_description.puller_type,
    op_puller.name AS puller_type_name,
    op_puller.short_name AS puller_type_short_name,
    order_description.lock_type,
    op_lock.name AS lock_type_name,
    op_lock.short_name AS lock_type_short_name,
    order_description.teeth_color,
    op_teeth_color.name AS teeth_color_name,
    op_teeth_color.short_name AS teeth_color_short_name,
    order_description.puller_color,
    op_puller_color.name AS puller_color_name,
    op_puller_color.short_name AS puller_color_short_name,
    order_description.hand,
    op_hand.name AS hand_name,
    op_hand.short_name AS hand_short_name,
    order_description.coloring_type,
    op_coloring.name AS coloring_type_name,
    op_coloring.short_name AS coloring_type_short_name,
    order_description.is_slider_provided,
    order_description.slider,
    op_slider.name AS slider_name,
    op_slider.short_name AS slider_short_name,
    order_description.slider_starting_section_enum AS slider_starting_section,
    order_description.top_stopper,
    op_top_stopper.name AS top_stopper_name,
    op_top_stopper.short_name AS top_stopper_short_name,
    order_description.bottom_stopper,
    op_bottom_stopper.name AS bottom_stopper_name,
    op_bottom_stopper.short_name AS bottom_stopper_short_name,
    order_description.logo_type,
    op_logo.name AS logo_type_name,
    op_logo.short_name AS logo_type_short_name,
    order_description.is_logo_body,
    order_description.is_logo_puller,
    order_description.special_requirement,
    order_description.description,
    order_description.status AS order_description_status,
    order_description.created_at AS order_description_created_at,
    order_description.updated_at AS order_description_updated_at,
    order_description.remarks,
    order_description.slider_body_shape,
    op_slider_body_shape.name AS slider_body_shape_name,
    op_slider_body_shape.short_name AS slider_body_shape_short_name,
    order_description.end_user,
    op_end_user.name AS end_user_name,
    op_end_user.short_name AS end_user_short_name,
    order_description.garment,
    order_description.light_preference,
    op_light_preference.name AS light_preference_name,
    op_light_preference.short_name AS light_preference_short_name,
    order_description.garments_wash,
    order_description.slider_link,
    op_slider_link.name AS slider_link_name,
    op_slider_link.short_name AS slider_link_short_name,
    order_info.marketing_priority,
    order_info.factory_priority,
    order_description.garments_remarks,
    stock.uuid AS stock_uuid,
    (stock.order_quantity)::double precision AS stock_order_quantity,
    order_description.tape_coil_uuid,
    tc.name AS tape_name,
    order_description.teeth_type,
    op_teeth_type.name AS teeth_type_name,
    op_teeth_type.short_name AS teeth_type_short_name,
    order_description.is_inch,
    order_description.is_meter,
    order_description.is_cm,
    order_description.order_type,
    order_description.is_multi_color
   FROM ((((((((((((((((((((((((((((zipper.order_info
     LEFT JOIN zipper.order_description ON ((order_description.order_info_uuid = order_info.uuid)))
     LEFT JOIN public.marketing ON ((marketing.uuid = order_info.marketing_uuid)))
     LEFT JOIN public.buyer ON ((buyer.uuid = order_info.buyer_uuid)))
     LEFT JOIN public.merchandiser ON ((merchandiser.uuid = order_info.merchandiser_uuid)))
     LEFT JOIN public.factory ON ((factory.uuid = order_info.factory_uuid)))
     LEFT JOIN hr.users users ON ((users.uuid = order_info.created_by)))
     LEFT JOIN public.party ON ((party.uuid = order_info.party_uuid)))
     LEFT JOIN public.properties op_item ON ((op_item.uuid = order_description.item)))
     LEFT JOIN public.properties op_nylon_stopper ON ((op_nylon_stopper.uuid = order_description.nylon_stopper)))
     LEFT JOIN public.properties op_zipper ON ((op_zipper.uuid = order_description.zipper_number)))
     LEFT JOIN public.properties op_end ON ((op_end.uuid = order_description.end_type)))
     LEFT JOIN public.properties op_puller ON ((op_puller.uuid = order_description.puller_type)))
     LEFT JOIN public.properties op_lock ON ((op_lock.uuid = order_description.lock_type)))
     LEFT JOIN public.properties op_teeth_color ON ((op_teeth_color.uuid = order_description.teeth_color)))
     LEFT JOIN public.properties op_puller_color ON ((op_puller_color.uuid = order_description.puller_color)))
     LEFT JOIN public.properties op_hand ON ((op_hand.uuid = order_description.hand)))
     LEFT JOIN public.properties op_coloring ON ((op_coloring.uuid = order_description.coloring_type)))
     LEFT JOIN public.properties op_slider ON ((op_slider.uuid = order_description.slider)))
     LEFT JOIN public.properties op_top_stopper ON ((op_top_stopper.uuid = order_description.top_stopper)))
     LEFT JOIN public.properties op_bottom_stopper ON ((op_bottom_stopper.uuid = order_description.bottom_stopper)))
     LEFT JOIN public.properties op_logo ON ((op_logo.uuid = order_description.logo_type)))
     LEFT JOIN public.properties op_slider_body_shape ON ((op_slider_body_shape.uuid = order_description.slider_body_shape)))
     LEFT JOIN public.properties op_slider_link ON ((op_slider_link.uuid = order_description.slider_link)))
     LEFT JOIN public.properties op_end_user ON ((op_end_user.uuid = order_description.end_user)))
     LEFT JOIN public.properties op_light_preference ON ((op_light_preference.uuid = order_description.light_preference)))
     LEFT JOIN slider.stock ON ((stock.order_description_uuid = order_description.uuid)))
     LEFT JOIN zipper.tape_coil tc ON ((tc.uuid = order_description.tape_coil_uuid)))
     LEFT JOIN public.properties op_teeth_type ON ((op_teeth_type.uuid = order_description.teeth_type)));
 '   DROP VIEW zipper.v_order_details_full;
       zipper          postgres    false    238    250    250    248    248    248    248    248    248    248    248    248    248    248    248    248    248    248    248    248    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    245    244    244    244    243    243    243    242    242    241    241    240    237    240    239    239    239    238    237    1057    1051    14    1054            �            1259    304848    v_packing_list    VIEW     �  CREATE VIEW delivery.v_packing_list AS
 SELECT pl.id AS packing_list_id,
    pl.uuid AS packing_list_uuid,
    concat('PL', to_char(pl.created_at, 'YY'::text), '-', lpad((pl.id)::text, 4, '0'::text)) AS packing_number,
    pl.carton_size,
    pl.carton_weight,
    pl.order_info_uuid,
    pl.challan_uuid,
    pl.created_by AS created_by_uuid,
    users.name AS created_by_name,
    pl.created_at,
    pl.updated_at,
    pl.remarks,
    ple.uuid AS packing_list_entry_uuid,
    ple.sfg_uuid,
    (ple.quantity)::double precision AS quantity,
    (ple.short_quantity)::double precision AS short_quantity,
    (ple.reject_quantity)::double precision AS reject_quantity,
    ple.created_at AS entry_created_at,
    ple.updated_at AS entry_updated_at,
    ple.remarks AS entry_remarks,
    oe.uuid AS order_entry_uuid,
    oe.style,
    oe.color,
        CASE
            WHEN (vodf.is_inch = 1) THEN (((oe.size)::numeric * 2.54))::text
            ELSE oe.size
        END AS size,
    concat(oe.style, ' / ', oe.color, ' / ',
        CASE
            WHEN (vodf.is_inch = 1) THEN (((oe.size)::numeric * 2.54))::text
            ELSE oe.size
        END) AS style_color_size,
    (oe.quantity)::double precision AS order_quantity,
    vodf.order_description_uuid,
    vodf.order_number,
    vodf.item_description,
    (sfg.warehouse)::double precision AS warehouse,
    (sfg.delivered)::double precision AS delivered,
    ((oe.quantity - sfg.warehouse))::double precision AS balance_quantity
   FROM (((((delivery.packing_list pl
     LEFT JOIN delivery.packing_list_entry ple ON ((ple.packing_list_uuid = pl.uuid)))
     LEFT JOIN hr.users ON ((users.uuid = pl.created_by)))
     LEFT JOIN zipper.sfg ON ((sfg.uuid = ple.sfg_uuid)))
     LEFT JOIN zipper.order_entry oe ON ((oe.uuid = sfg.order_entry_uuid)))
     LEFT JOIN zipper.v_order_details_full vodf ON ((vodf.order_description_uuid = oe.order_description_uuid)));
 #   DROP VIEW delivery.v_packing_list;
       delivery          postgres    false    235    235    235    235    235    235    235    235    235    235    236    236    236    236    236    236    236    236    236    237    237    246    246    246    246    246    246    249    249    249    249    251    251    251    251    6            �            1259    304853    migrations_details    TABLE     t   CREATE TABLE drizzle.migrations_details (
    id integer NOT NULL,
    hash text NOT NULL,
    created_at bigint
);
 '   DROP TABLE drizzle.migrations_details;
       drizzle         heap    postgres    false    7            �            1259    304858    migrations_details_id_seq    SEQUENCE     �   CREATE SEQUENCE drizzle.migrations_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE drizzle.migrations_details_id_seq;
       drizzle          postgres    false    7    253            �           0    0    migrations_details_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE drizzle.migrations_details_id_seq OWNED BY drizzle.migrations_details.id;
          drizzle          postgres    false    254            �            1259    304859 
   department    TABLE     �   CREATE TABLE hr.department (
    uuid text NOT NULL,
    department text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
    DROP TABLE hr.department;
       hr         heap    postgres    false    8                        1259    304864    designation    TABLE     �   CREATE TABLE hr.designation (
    uuid text NOT NULL,
    designation text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
    DROP TABLE hr.designation;
       hr         heap    postgres    false    8                       1259    304869    policy_and_notice    TABLE       CREATE TABLE hr.policy_and_notice (
    uuid text NOT NULL,
    type text NOT NULL,
    title text NOT NULL,
    sub_title text NOT NULL,
    url text NOT NULL,
    created_at text NOT NULL,
    updated_at text,
    status integer NOT NULL,
    remarks text,
    created_by text
);
 !   DROP TABLE hr.policy_and_notice;
       hr         heap    postgres    false    8                       1259    304874    info    TABLE     L  CREATE TABLE lab_dip.info (
    uuid text NOT NULL,
    id integer NOT NULL,
    name text NOT NULL,
    order_info_uuid text,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    lab_status integer DEFAULT 0,
    thread_order_info_uuid text
);
    DROP TABLE lab_dip.info;
       lab_dip         heap    postgres    false    9                       1259    304880    info_id_seq    SEQUENCE     �   CREATE SEQUENCE lab_dip.info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE lab_dip.info_id_seq;
       lab_dip          postgres    false    9    258            �           0    0    info_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE lab_dip.info_id_seq OWNED BY lab_dip.info.id;
          lab_dip          postgres    false    259                       1259    304881    recipe    TABLE     t  CREATE TABLE lab_dip.recipe (
    uuid text NOT NULL,
    id integer NOT NULL,
    lab_dip_info_uuid text,
    name text NOT NULL,
    approved integer DEFAULT 0,
    created_by text,
    status integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    sub_streat text,
    bleaching text
);
    DROP TABLE lab_dip.recipe;
       lab_dip         heap    postgres    false    9                       1259    304888    recipe_entry    TABLE       CREATE TABLE lab_dip.recipe_entry (
    uuid text NOT NULL,
    recipe_uuid text,
    color text NOT NULL,
    quantity numeric(20,4) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    material_uuid text
);
 !   DROP TABLE lab_dip.recipe_entry;
       lab_dip         heap    postgres    false    9                       1259    304893    recipe_id_seq    SEQUENCE     �   CREATE SEQUENCE lab_dip.recipe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE lab_dip.recipe_id_seq;
       lab_dip          postgres    false    9    260            �           0    0    recipe_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE lab_dip.recipe_id_seq OWNED BY lab_dip.recipe.id;
          lab_dip          postgres    false    262                       1259    304894    shade_recipe_sequence    SEQUENCE        CREATE SEQUENCE lab_dip.shade_recipe_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE lab_dip.shade_recipe_sequence;
       lab_dip          postgres    false    9                       1259    304895    shade_recipe    TABLE     }  CREATE TABLE lab_dip.shade_recipe (
    uuid text NOT NULL,
    id integer DEFAULT nextval('lab_dip.shade_recipe_sequence'::regclass) NOT NULL,
    name text NOT NULL,
    sub_streat text,
    lab_status integer DEFAULT 0,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    bleaching text
);
 !   DROP TABLE lab_dip.shade_recipe;
       lab_dip         heap    postgres    false    263    9            	           1259    304902    shade_recipe_entry    TABLE       CREATE TABLE lab_dip.shade_recipe_entry (
    uuid text NOT NULL,
    shade_recipe_uuid text,
    material_uuid text,
    quantity numeric(20,4) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 '   DROP TABLE lab_dip.shade_recipe_entry;
       lab_dip         heap    postgres    false    9            
           1259    304907    info    TABLE     �  CREATE TABLE material.info (
    uuid text NOT NULL,
    section_uuid text,
    type_uuid text,
    name text NOT NULL,
    short_name text,
    unit text NOT NULL,
    threshold numeric(20,4) DEFAULT 0 NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    created_by text,
    average_lead_time integer DEFAULT 0
);
    DROP TABLE material.info;
       material         heap    postgres    false    10                       1259    304914    section    TABLE     �   CREATE TABLE material.section (
    uuid text NOT NULL,
    name text NOT NULL,
    short_name text,
    remarks text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    created_by text
);
    DROP TABLE material.section;
       material         heap    postgres    false    10                       1259    304919    stock    TABLE     �  CREATE TABLE material.stock (
    uuid text NOT NULL,
    material_uuid text,
    stock numeric(20,4) DEFAULT 0 NOT NULL,
    tape_making numeric(20,4) DEFAULT 0 NOT NULL,
    coil_forming numeric(20,4) DEFAULT 0 NOT NULL,
    dying_and_iron numeric(20,4) DEFAULT 0 NOT NULL,
    m_gapping numeric(20,4) DEFAULT 0 NOT NULL,
    v_gapping numeric(20,4) DEFAULT 0 NOT NULL,
    v_teeth_molding numeric(20,4) DEFAULT 0 NOT NULL,
    m_teeth_molding numeric(20,4) DEFAULT 0 NOT NULL,
    teeth_assembling_and_polishing numeric(20,4) DEFAULT 0 NOT NULL,
    m_teeth_cleaning numeric(20,4) DEFAULT 0 NOT NULL,
    v_teeth_cleaning numeric(20,4) DEFAULT 0 NOT NULL,
    plating_and_iron numeric(20,4) DEFAULT 0 NOT NULL,
    m_sealing numeric(20,4) DEFAULT 0 NOT NULL,
    v_sealing numeric(20,4) DEFAULT 0 NOT NULL,
    n_t_cutting numeric(20,4) DEFAULT 0 NOT NULL,
    v_t_cutting numeric(20,4) DEFAULT 0 NOT NULL,
    m_stopper numeric(20,4) DEFAULT 0 NOT NULL,
    v_stopper numeric(20,4) DEFAULT 0 NOT NULL,
    n_stopper numeric(20,4) DEFAULT 0 NOT NULL,
    cutting numeric(20,4) DEFAULT 0 NOT NULL,
    die_casting numeric(20,4) DEFAULT 0 NOT NULL,
    slider_assembly numeric(20,4) DEFAULT 0 NOT NULL,
    coloring numeric(20,4) DEFAULT 0 NOT NULL,
    remarks text,
    lab_dip numeric(20,4) DEFAULT 0,
    m_qc_and_packing numeric(20,4) DEFAULT 0 NOT NULL,
    v_qc_and_packing numeric(20,4) DEFAULT 0 NOT NULL,
    n_qc_and_packing numeric(20,4) DEFAULT 0 NOT NULL,
    s_qc_and_packing numeric(20,4) DEFAULT 0 NOT NULL
);
    DROP TABLE material.stock;
       material         heap    postgres    false    10                       1259    304952    stock_to_sfg    TABLE     =  CREATE TABLE material.stock_to_sfg (
    uuid text NOT NULL,
    material_uuid text,
    order_entry_uuid text,
    trx_to text NOT NULL,
    trx_quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 "   DROP TABLE material.stock_to_sfg;
       material         heap    postgres    false    10                       1259    304957    trx    TABLE       CREATE TABLE material.trx (
    uuid text NOT NULL,
    material_uuid text,
    trx_to text NOT NULL,
    trx_quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
    DROP TABLE material.trx;
       material         heap    postgres    false    10                       1259    304962    type    TABLE     �   CREATE TABLE material.type (
    uuid text NOT NULL,
    name text NOT NULL,
    short_name text,
    remarks text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    created_by text
);
    DROP TABLE material.type;
       material         heap    postgres    false    10                       1259    304967    used    TABLE     J  CREATE TABLE material.used (
    uuid text NOT NULL,
    material_uuid text,
    section text NOT NULL,
    used_quantity numeric(20,4) NOT NULL,
    wastage numeric(20,4) DEFAULT 0 NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
    DROP TABLE material.used;
       material         heap    postgres    false    10                       1259    304973    machine    TABLE     1  CREATE TABLE public.machine (
    uuid text NOT NULL,
    name text NOT NULL,
    is_vislon integer DEFAULT 0,
    is_metal integer DEFAULT 0,
    is_nylon integer DEFAULT 0,
    is_sewing_thread integer DEFAULT 0,
    is_bulk integer DEFAULT 0,
    is_sample integer DEFAULT 0,
    min_capacity numeric(20,4) NOT NULL,
    max_capacity numeric(20,4) NOT NULL,
    water_capacity numeric(20,4) DEFAULT 0 NOT NULL,
    created_by text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
    DROP TABLE public.machine;
       public         heap    postgres    false    15                       1259    304985    section    TABLE     w   CREATE TABLE public.section (
    uuid text NOT NULL,
    name text NOT NULL,
    short_name text,
    remarks text
);
    DROP TABLE public.section;
       public         heap    postgres    false    15                       1259    304990    purchase_description_sequence    SEQUENCE     �   CREATE SEQUENCE purchase.purchase_description_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE purchase.purchase_description_sequence;
       purchase          postgres    false    11                       1259    304991    description    TABLE     �  CREATE TABLE purchase.description (
    uuid text NOT NULL,
    vendor_uuid text,
    is_local integer NOT NULL,
    lc_number text,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    id integer DEFAULT nextval('purchase.purchase_description_sequence'::regclass) NOT NULL,
    challan_number text
);
 !   DROP TABLE purchase.description;
       purchase         heap    postgres    false    275    11                       1259    304997    entry    TABLE     ;  CREATE TABLE purchase.entry (
    uuid text NOT NULL,
    purchase_description_uuid text,
    material_uuid text,
    quantity numeric(20,4) NOT NULL,
    price numeric(20,4) DEFAULT NULL::numeric,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
    DROP TABLE purchase.entry;
       purchase         heap    postgres    false    11                       1259    305003    vendor    TABLE     M  CREATE TABLE purchase.vendor (
    uuid text NOT NULL,
    name text NOT NULL,
    contact_name text NOT NULL,
    email text NOT NULL,
    office_address text NOT NULL,
    contact_number text,
    remarks text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    created_by text
);
    DROP TABLE purchase.vendor;
       purchase         heap    postgres    false    11                       1259    305008    assembly_stock    TABLE     �  CREATE TABLE slider.assembly_stock (
    uuid text NOT NULL,
    name text NOT NULL,
    die_casting_body_uuid text,
    die_casting_puller_uuid text,
    die_casting_cap_uuid text,
    die_casting_link_uuid text,
    quantity numeric(20,4) DEFAULT 0 NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    weight numeric(20,4) DEFAULT 0 NOT NULL
);
 "   DROP TABLE slider.assembly_stock;
       slider         heap    postgres    false    12                       1259    305015    coloring_transaction    TABLE     R  CREATE TABLE slider.coloring_transaction (
    uuid text NOT NULL,
    stock_uuid text,
    order_info_uuid text,
    trx_quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    weight numeric(20,4) DEFAULT 0 NOT NULL
);
 (   DROP TABLE slider.coloring_transaction;
       slider         heap    postgres    false    12                       1259    305021    die_casting    TABLE     i  CREATE TABLE slider.die_casting (
    uuid text NOT NULL,
    name text NOT NULL,
    item text,
    zipper_number text,
    end_type text,
    puller_type text,
    logo_type text,
    slider_body_shape text,
    slider_link text,
    quantity numeric(20,4) DEFAULT 0,
    weight numeric(20,4) DEFAULT 0,
    pcs_per_kg numeric(20,4) DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    quantity_in_sa numeric(20,4) DEFAULT 0,
    is_logo_body integer DEFAULT 0,
    is_logo_puller integer DEFAULT 0,
    type text,
    created_by text
);
    DROP TABLE slider.die_casting;
       slider         heap    postgres    false    12                       1259    305032    die_casting_production    TABLE     �  CREATE TABLE slider.die_casting_production (
    uuid text NOT NULL,
    die_casting_uuid text,
    mc_no integer NOT NULL,
    cavity_goods integer NOT NULL,
    cavity_defect integer NOT NULL,
    push integer NOT NULL,
    weight numeric(20,4) NOT NULL,
    order_description_uuid text,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 *   DROP TABLE slider.die_casting_production;
       slider         heap    postgres    false    12                       1259    305037    die_casting_to_assembly_stock    TABLE     �  CREATE TABLE slider.die_casting_to_assembly_stock (
    uuid text NOT NULL,
    assembly_stock_uuid text,
    production_quantity numeric(20,4) DEFAULT 0 NOT NULL,
    wastage numeric(20,4) DEFAULT 0 NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    with_link integer DEFAULT 1,
    weight numeric(20,4) DEFAULT 0 NOT NULL
);
 1   DROP TABLE slider.die_casting_to_assembly_stock;
       slider         heap    postgres    false    12                       1259    305046    die_casting_transaction    TABLE     V  CREATE TABLE slider.die_casting_transaction (
    uuid text NOT NULL,
    die_casting_uuid text,
    stock_uuid text,
    trx_quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    weight numeric(20,4) DEFAULT 0 NOT NULL
);
 +   DROP TABLE slider.die_casting_transaction;
       slider         heap    postgres    false    12                       1259    305052 
   production    TABLE     �  CREATE TABLE slider.production (
    uuid text NOT NULL,
    stock_uuid text,
    production_quantity numeric(20,4) NOT NULL,
    wastage numeric(20,4) NOT NULL,
    section text,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    with_link integer DEFAULT 1,
    weight numeric(20,4) DEFAULT 0 NOT NULL
);
    DROP TABLE slider.production;
       slider         heap    postgres    false    12                       1259    305059    transaction    TABLE     �  CREATE TABLE slider.transaction (
    uuid text NOT NULL,
    stock_uuid text,
    trx_quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    from_section text NOT NULL,
    to_section text NOT NULL,
    assembly_stock_uuid text,
    weight numeric(20,4) DEFAULT 0 NOT NULL
);
    DROP TABLE slider.transaction;
       slider         heap    postgres    false    12                       1259    305065    trx_against_stock    TABLE     7  CREATE TABLE slider.trx_against_stock (
    uuid text NOT NULL,
    die_casting_uuid text,
    quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    weight numeric(20,4) DEFAULT 0 NOT NULL
);
 %   DROP TABLE slider.trx_against_stock;
       slider         heap    postgres    false    12                        1259    305071    thread_batch_sequence    SEQUENCE     ~   CREATE SEQUENCE thread.thread_batch_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE thread.thread_batch_sequence;
       thread          postgres    false    13            !           1259    305072    batch    TABLE     �  CREATE TABLE thread.batch (
    uuid text NOT NULL,
    id integer DEFAULT nextval('thread.thread_batch_sequence'::regclass) NOT NULL,
    dyeing_operator text,
    reason text,
    category text,
    status text,
    pass_by text,
    shift text,
    dyeing_supervisor text,
    coning_operator text,
    coning_supervisor text,
    coning_machines text,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    yarn_quantity numeric(20,4) DEFAULT 0 NOT NULL,
    machine_uuid text,
    lab_created_by text,
    lab_created_at timestamp without time zone,
    lab_updated_at timestamp without time zone,
    yarn_issue_created_by text,
    yarn_issue_created_at timestamp without time zone,
    yarn_issue_updated_at timestamp without time zone,
    is_drying_complete text,
    drying_created_at timestamp without time zone,
    drying_updated_at timestamp without time zone,
    dyeing_created_by text,
    dyeing_created_at timestamp without time zone,
    dyeing_updated_at timestamp without time zone,
    coning_created_by text,
    coning_created_at timestamp without time zone,
    coning_updated_at timestamp without time zone,
    slot integer DEFAULT 0
);
    DROP TABLE thread.batch;
       thread         heap    postgres    false    288    13            "           1259    305080    batch_entry    TABLE     �  CREATE TABLE thread.batch_entry (
    uuid text NOT NULL,
    batch_uuid text,
    order_entry_uuid text,
    quantity numeric(20,4) DEFAULT 0 NOT NULL,
    coning_production_quantity numeric(20,4) DEFAULT 0 NOT NULL,
    coning_carton_quantity numeric(20,4) DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    coning_created_at timestamp without time zone,
    coning_updated_at timestamp without time zone,
    transfer_quantity numeric(20,4) DEFAULT 0 NOT NULL,
    transfer_carton_quantity integer DEFAULT 0,
    yarn_quantity numeric(20,4) DEFAULT 0 NOT NULL
);
    DROP TABLE thread.batch_entry;
       thread         heap    postgres    false    13            #           1259    305091    batch_entry_production    TABLE     M  CREATE TABLE thread.batch_entry_production (
    uuid text NOT NULL,
    batch_entry_uuid text,
    production_quantity numeric(20,4) NOT NULL,
    coning_carton_quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 *   DROP TABLE thread.batch_entry_production;
       thread         heap    postgres    false    13            $           1259    305096    batch_entry_trx    TABLE     /  CREATE TABLE thread.batch_entry_trx (
    uuid text NOT NULL,
    batch_entry_uuid text,
    quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    carton_quantity integer DEFAULT 0
);
 #   DROP TABLE thread.batch_entry_trx;
       thread         heap    postgres    false    13            %           1259    305102    thread_challan_sequence    SEQUENCE     �   CREATE SEQUENCE thread.thread_challan_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE thread.thread_challan_sequence;
       thread          postgres    false    13            &           1259    305103    challan    TABLE     �  CREATE TABLE thread.challan (
    uuid text NOT NULL,
    order_info_uuid text,
    carton_quantity integer NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    assign_to text,
    gate_pass integer DEFAULT 0,
    received integer DEFAULT 0,
    id integer DEFAULT nextval('thread.thread_challan_sequence'::regclass)
);
    DROP TABLE thread.challan;
       thread         heap    postgres    false    293    13            '           1259    305111    challan_entry    TABLE     �  CREATE TABLE thread.challan_entry (
    uuid text NOT NULL,
    challan_uuid text,
    order_entry_uuid text,
    quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    short_quantity numeric(20,4) DEFAULT 0 NOT NULL,
    reject_quantity numeric(20,4) DEFAULT 0 NOT NULL
);
 !   DROP TABLE thread.challan_entry;
       thread         heap    postgres    false    13            (           1259    305118    count_length    TABLE     �  CREATE TABLE thread.count_length (
    uuid text NOT NULL,
    count text NOT NULL,
    sst text NOT NULL,
    created_by text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    min_weight numeric(20,4),
    max_weight numeric(20,4),
    length numeric NOT NULL,
    price numeric(20,4) NOT NULL,
    cone_per_carton integer DEFAULT 0 NOT NULL
);
     DROP TABLE thread.count_length;
       thread         heap    postgres    false    13            )           1259    305124    dyes_category    TABLE     B  CREATE TABLE thread.dyes_category (
    uuid text NOT NULL,
    name text NOT NULL,
    upto_percentage numeric(20,4) DEFAULT 0 NOT NULL,
    bleaching text,
    id integer DEFAULT 0,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 !   DROP TABLE thread.dyes_category;
       thread         heap    postgres    false    13            *           1259    305131    order_entry    TABLE        CREATE TABLE thread.order_entry (
    uuid text NOT NULL,
    order_info_uuid text,
    lab_reference text,
    color text NOT NULL,
    po text,
    style text,
    count_length_uuid text,
    quantity numeric(20,4) NOT NULL,
    company_price numeric(20,4) DEFAULT 0 NOT NULL,
    party_price numeric(20,4) DEFAULT 0 NOT NULL,
    swatch_approval_date timestamp without time zone,
    production_quantity numeric(20,4) DEFAULT 0 NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    bleaching text,
    transfer_quantity numeric(20,4) DEFAULT 0 NOT NULL,
    recipe_uuid text,
    pi numeric(20,4) DEFAULT 0 NOT NULL,
    delivered numeric(20,4) DEFAULT 0 NOT NULL,
    warehouse numeric(20,4) DEFAULT 0 NOT NULL,
    short_quantity numeric(20,4) DEFAULT 0 NOT NULL,
    reject_quantity numeric(20,4) DEFAULT 0 NOT NULL,
    production_quantity_in_kg numeric(20,4) DEFAULT 0 NOT NULL,
    carton_quantity integer DEFAULT 0
);
    DROP TABLE thread.order_entry;
       thread         heap    postgres    false    13            +           1259    305147    thread_order_info_sequence    SEQUENCE     �   CREATE SEQUENCE thread.thread_order_info_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE thread.thread_order_info_sequence;
       thread          postgres    false    13            ,           1259    305148 
   order_info    TABLE       CREATE TABLE thread.order_info (
    uuid text NOT NULL,
    id integer DEFAULT nextval('thread.thread_order_info_sequence'::regclass) NOT NULL,
    party_uuid text,
    marketing_uuid text,
    factory_uuid text,
    merchandiser_uuid text,
    buyer_uuid text,
    is_sample integer DEFAULT 0,
    is_bill integer DEFAULT 0,
    delivery_date timestamp without time zone,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    is_cash integer DEFAULT 0
);
    DROP TABLE thread.order_info;
       thread         heap    postgres    false    299    13            -           1259    305157    programs    TABLE     %  CREATE TABLE thread.programs (
    uuid text NOT NULL,
    dyes_category_uuid text,
    material_uuid text,
    quantity numeric(20,4) DEFAULT 0 NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
    DROP TABLE thread.programs;
       thread         heap    postgres    false    13            .           1259    305163    batch    TABLE     w  CREATE TABLE zipper.batch (
    uuid text NOT NULL,
    id integer NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    batch_status zipper.batch_status DEFAULT 'pending'::zipper.batch_status,
    machine_uuid text,
    slot integer DEFAULT 0,
    received integer DEFAULT 0
);
    DROP TABLE zipper.batch;
       zipper         heap    postgres    false    1048    14    1048            /           1259    305171    batch_entry    TABLE     n  CREATE TABLE zipper.batch_entry (
    uuid text NOT NULL,
    batch_uuid text,
    quantity numeric(20,4) DEFAULT 0 NOT NULL,
    production_quantity numeric(20,4) DEFAULT 0,
    production_quantity_in_kg numeric(20,4) DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    sfg_uuid text
);
    DROP TABLE zipper.batch_entry;
       zipper         heap    postgres    false    14            0           1259    305179    batch_id_seq    SEQUENCE     �   CREATE SEQUENCE zipper.batch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE zipper.batch_id_seq;
       zipper          postgres    false    302    14            �           0    0    batch_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE zipper.batch_id_seq OWNED BY zipper.batch.id;
          zipper          postgres    false    304            1           1259    305180    batch_production    TABLE     J  CREATE TABLE zipper.batch_production (
    uuid text NOT NULL,
    batch_entry_uuid text,
    production_quantity numeric(20,4) NOT NULL,
    production_quantity_in_kg numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 $   DROP TABLE zipper.batch_production;
       zipper         heap    postgres    false    14            2           1259    305185    dyed_tape_transaction    TABLE     )  CREATE TABLE zipper.dyed_tape_transaction (
    uuid text NOT NULL,
    order_description_uuid text,
    colors text,
    trx_quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 )   DROP TABLE zipper.dyed_tape_transaction;
       zipper         heap    postgres    false    14            3           1259    305190     dyed_tape_transaction_from_stock    TABLE     F  CREATE TABLE zipper.dyed_tape_transaction_from_stock (
    uuid text NOT NULL,
    order_description_uuid text,
    trx_quantity numeric(20,4) DEFAULT 0 NOT NULL,
    tape_coil_uuid text,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 4   DROP TABLE zipper.dyed_tape_transaction_from_stock;
       zipper         heap    postgres    false    14            4           1259    305196    dying_batch    TABLE     �   CREATE TABLE zipper.dying_batch (
    uuid text NOT NULL,
    id integer NOT NULL,
    mc_no integer NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
    DROP TABLE zipper.dying_batch;
       zipper         heap    postgres    false    14            5           1259    305201    dying_batch_entry    TABLE     v  CREATE TABLE zipper.dying_batch_entry (
    uuid text NOT NULL,
    dying_batch_uuid text,
    batch_entry_uuid text,
    quantity numeric(20,4) NOT NULL,
    production_quantity numeric(20,4) NOT NULL,
    production_quantity_in_kg numeric(20,4) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 %   DROP TABLE zipper.dying_batch_entry;
       zipper         heap    postgres    false    14            6           1259    305206    dying_batch_id_seq    SEQUENCE     �   CREATE SEQUENCE zipper.dying_batch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE zipper.dying_batch_id_seq;
       zipper          postgres    false    308    14            �           0    0    dying_batch_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE zipper.dying_batch_id_seq OWNED BY zipper.dying_batch.id;
          zipper          postgres    false    310            7           1259    305207 &   material_trx_against_order_description    TABLE     [  CREATE TABLE zipper.material_trx_against_order_description (
    uuid text NOT NULL,
    order_description_uuid text,
    material_uuid text,
    trx_to text NOT NULL,
    trx_quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 :   DROP TABLE zipper.material_trx_against_order_description;
       zipper         heap    postgres    false    14            8           1259    305212    multi_color_dashboard    TABLE     �  CREATE TABLE zipper.multi_color_dashboard (
    uuid text NOT NULL,
    order_description_uuid text,
    expected_tape_quantity numeric(20,4) DEFAULT 0,
    is_swatch_approved integer DEFAULT 0,
    tape_quantity numeric(20,4) DEFAULT 0,
    coil_uuid text,
    coil_quantity numeric(20,4) DEFAULT 0,
    thread_name text,
    thread_quantity numeric(20,4) DEFAULT 0,
    is_coil_received_sewing integer DEFAULT 0,
    is_thread_received_sewing integer DEFAULT 0,
    remarks text
);
 )   DROP TABLE zipper.multi_color_dashboard;
       zipper         heap    postgres    false    14            9           1259    305224    multi_color_tape_receive    TABLE       CREATE TABLE zipper.multi_color_tape_receive (
    uuid text NOT NULL,
    order_description_uuid text,
    quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 ,   DROP TABLE zipper.multi_color_tape_receive;
       zipper         heap    postgres    false    14            :           1259    305229    planning    TABLE     �   CREATE TABLE zipper.planning (
    week text NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
    DROP TABLE zipper.planning;
       zipper         heap    postgres    false    14            ;           1259    305234    planning_entry    TABLE     �  CREATE TABLE zipper.planning_entry (
    uuid text NOT NULL,
    sfg_uuid text,
    sno_quantity numeric(20,4) DEFAULT 0,
    factory_quantity numeric(20,4) DEFAULT 0,
    production_quantity numeric(20,4) DEFAULT 0,
    batch_production_quantity numeric(20,4) DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    planning_week text,
    sno_remarks text,
    factory_remarks text
);
 "   DROP TABLE zipper.planning_entry;
       zipper         heap    postgres    false    14            <           1259    305243    sfg_production    TABLE     �  CREATE TABLE zipper.sfg_production (
    uuid text NOT NULL,
    sfg_uuid text,
    section text NOT NULL,
    production_quantity_in_kg numeric(20,4) DEFAULT 0,
    production_quantity numeric(20,4) DEFAULT 0,
    wastage numeric(20,4) DEFAULT 0,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 "   DROP TABLE zipper.sfg_production;
       zipper         heap    postgres    false    14            =           1259    305251    sfg_transaction    TABLE     �  CREATE TABLE zipper.sfg_transaction (
    uuid text NOT NULL,
    trx_from text NOT NULL,
    trx_to text NOT NULL,
    trx_quantity numeric(20,4) DEFAULT 0,
    slider_item_uuid text,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    sfg_uuid text,
    trx_quantity_in_kg numeric(20,4) DEFAULT 0 NOT NULL
);
 #   DROP TABLE zipper.sfg_transaction;
       zipper         heap    postgres    false    14            >           1259    305258    tape_coil_production    TABLE     _  CREATE TABLE zipper.tape_coil_production (
    uuid text NOT NULL,
    section text NOT NULL,
    tape_coil_uuid text,
    production_quantity numeric(20,4) NOT NULL,
    wastage numeric(20,4) DEFAULT 0 NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 (   DROP TABLE zipper.tape_coil_production;
       zipper         heap    postgres    false    14            ?           1259    305264    tape_coil_required    TABLE     t  CREATE TABLE zipper.tape_coil_required (
    uuid text NOT NULL,
    end_type_uuid text,
    item_uuid text,
    nylon_stopper_uuid text,
    zipper_number_uuid text,
    top numeric(20,4) NOT NULL,
    bottom numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text
);
 &   DROP TABLE zipper.tape_coil_required;
       zipper         heap    postgres    false    14            @           1259    305269    tape_coil_to_dyeing    TABLE     \  CREATE TABLE zipper.tape_coil_to_dyeing (
    uuid text NOT NULL,
    tape_coil_uuid text,
    order_description_uuid text,
    trx_quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    is_received_in_sewing integer DEFAULT 0
);
 '   DROP TABLE zipper.tape_coil_to_dyeing;
       zipper         heap    postgres    false    14            A           1259    305275    tape_trx    TABLE       CREATE TABLE zipper.tape_trx (
    uuid text NOT NULL,
    tape_coil_uuid text,
    trx_quantity numeric(20,4) NOT NULL,
    created_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    remarks text,
    to_section text
);
    DROP TABLE zipper.tape_trx;
       zipper         heap    postgres    false    14            B           1259    305280    v_order_details    VIEW     �	  CREATE VIEW zipper.v_order_details AS
 SELECT order_info.uuid AS order_info_uuid,
    order_info.reference_order_info_uuid,
    concat('Z', to_char(order_info.created_at, 'YY'::text), '-', lpad((order_info.id)::text, 4, '0'::text)) AS order_number,
    concat(op_item.short_name, op_nylon_stopper.short_name, '-', op_zipper.short_name, '-', op_end.short_name, '-', op_puller.short_name) AS item_description,
    op_item.name AS item_name,
    op_nylon_stopper.name AS nylon_stopper_name,
    op_zipper.name AS zipper_number_name,
    op_end.name AS end_type_name,
    op_puller.name AS puller_type_name,
    order_description.uuid AS order_description_uuid,
    order_info.buyer_uuid,
    buyer.name AS buyer_name,
    order_info.party_uuid,
    party.name AS party_name,
    order_info.marketing_uuid,
    marketing.name AS marketing_name,
    order_info.merchandiser_uuid,
    merchandiser.name AS merchandiser_name,
    order_info.factory_uuid,
    factory.name AS factory_name,
    order_info.is_sample,
    order_info.is_bill,
    order_info.is_cash,
    order_info.marketing_priority,
    order_info.factory_priority,
    order_info.status,
    order_info.created_by AS created_by_uuid,
    users.name AS created_by_name,
    order_info.created_at,
    order_info.updated_at,
    order_info.remarks,
    order_description.is_inch,
    order_description.is_meter,
    order_description.is_cm,
    order_description.order_type,
    order_description.is_multi_color
   FROM ((((((((((((zipper.order_info
     LEFT JOIN zipper.order_description ON ((order_description.order_info_uuid = order_info.uuid)))
     LEFT JOIN public.marketing ON ((marketing.uuid = order_info.marketing_uuid)))
     LEFT JOIN public.buyer ON ((buyer.uuid = order_info.buyer_uuid)))
     LEFT JOIN public.merchandiser ON ((merchandiser.uuid = order_info.merchandiser_uuid)))
     LEFT JOIN public.factory ON ((factory.uuid = order_info.factory_uuid)))
     LEFT JOIN hr.users ON ((users.uuid = order_info.created_by)))
     LEFT JOIN public.party ON ((party.uuid = order_info.party_uuid)))
     LEFT JOIN public.properties op_item ON ((op_item.uuid = order_description.item)))
     LEFT JOIN public.properties op_zipper ON ((op_zipper.uuid = order_description.zipper_number)))
     LEFT JOIN public.properties op_end ON ((op_end.uuid = order_description.end_type)))
     LEFT JOIN public.properties op_puller ON ((op_puller.uuid = order_description.puller_type)))
     LEFT JOIN public.properties op_nylon_stopper ON ((op_nylon_stopper.uuid = order_description.nylon_stopper)));
 "   DROP VIEW zipper.v_order_details;
       zipper          postgres    false    248    237    237    248    245    245    245    248    248    248    248    245    245    248    248    239    239    240    240    241    241    242    242    243    248    243    243    245    248    248    248    248    245    245    245    238    248    248    248    245    245    245    248    238    248    14    1051            w           2604    305285    migrations_details id    DEFAULT     �   ALTER TABLE ONLY drizzle.migrations_details ALTER COLUMN id SET DEFAULT nextval('drizzle.migrations_details_id_seq'::regclass);
 E   ALTER TABLE drizzle.migrations_details ALTER COLUMN id DROP DEFAULT;
       drizzle          postgres    false    254    253            x           2604    305286    info id    DEFAULT     d   ALTER TABLE ONLY lab_dip.info ALTER COLUMN id SET DEFAULT nextval('lab_dip.info_id_seq'::regclass);
 7   ALTER TABLE lab_dip.info ALTER COLUMN id DROP DEFAULT;
       lab_dip          postgres    false    259    258            z           2604    305287 	   recipe id    DEFAULT     h   ALTER TABLE ONLY lab_dip.recipe ALTER COLUMN id SET DEFAULT nextval('lab_dip.recipe_id_seq'::regclass);
 9   ALTER TABLE lab_dip.recipe ALTER COLUMN id DROP DEFAULT;
       lab_dip          postgres    false    262    260            �           2604    305288    batch id    DEFAULT     d   ALTER TABLE ONLY zipper.batch ALTER COLUMN id SET DEFAULT nextval('zipper.batch_id_seq'::regclass);
 7   ALTER TABLE zipper.batch ALTER COLUMN id DROP DEFAULT;
       zipper          postgres    false    304    302            �           2604    305289    dying_batch id    DEFAULT     p   ALTER TABLE ONLY zipper.dying_batch ALTER COLUMN id SET DEFAULT nextval('zipper.dying_batch_id_seq'::regclass);
 =   ALTER TABLE zipper.dying_batch ALTER COLUMN id DROP DEFAULT;
       zipper          postgres    false    310    308            f          0    304650    bank 
   TABLE DATA           �   COPY commercial.bank (uuid, name, swift_code, address, policy, created_at, updated_at, remarks, created_by, routing_no) FROM stdin;
 
   commercial          postgres    false    225   �x      h          0    304656    lc 
   TABLE DATA           �  COPY commercial.lc (uuid, party_uuid, lc_number, lc_date, payment_date, ldbc_fdbc, acceptance_date, maturity_date, commercial_executive, party_bank, production_complete, lc_cancel, handover_date, shipment_date, expiry_date, ud_no, ud_received, at_sight, amd_date, amd_count, problematical, epz, created_by, created_at, updated_at, remarks, id, document_receive_date, is_rtgs, lc_value, is_old_pi, pi_number, payment_value) FROM stdin;
 
   commercial          postgres    false    227   ,{      j          0    304672    pi_cash 
   TABLE DATA             COPY commercial.pi_cash (uuid, id, lc_uuid, order_info_uuids, marketing_uuid, party_uuid, merchandiser_uuid, factory_uuid, bank_uuid, validity, payment, is_pi, conversion_rate, receive_amount, created_by, created_at, updated_at, remarks, weight, thread_order_info_uuids) FROM stdin;
 
   commercial          postgres    false    229   z|      k          0    304684    pi_cash_entry 
   TABLE DATA           �   COPY commercial.pi_cash_entry (uuid, pi_cash_uuid, sfg_uuid, pi_cash_quantity, created_at, updated_at, remarks, thread_order_entry_uuid) FROM stdin;
 
   commercial          postgres    false    230   B�      m          0    304690    challan 
   TABLE DATA           �   COPY delivery.challan (uuid, carton_quantity, assign_to, receive_status, created_by, created_at, updated_at, remarks, id, gate_pass, order_info_uuid) FROM stdin;
    delivery          postgres    false    232   ��      n          0    304698    challan_entry 
   TABLE DATA           q   COPY delivery.challan_entry (uuid, challan_uuid, packing_list_uuid, created_at, updated_at, remarks) FROM stdin;
    delivery          postgres    false    233   ��      p          0    304704    packing_list 
   TABLE DATA           �   COPY delivery.packing_list (uuid, carton_size, carton_weight, created_by, created_at, updated_at, remarks, order_info_uuid, id, challan_uuid) FROM stdin;
    delivery          postgres    false    235   ė      q          0    304710    packing_list_entry 
   TABLE DATA           �   COPY delivery.packing_list_entry (uuid, packing_list_uuid, sfg_uuid, quantity, created_at, updated_at, remarks, short_quantity, reject_quantity) FROM stdin;
    delivery          postgres    false    236   z�      �          0    304853    migrations_details 
   TABLE DATA           C   COPY drizzle.migrations_details (id, hash, created_at) FROM stdin;
    drizzle          postgres    false    253   ��      �          0    304859 
   department 
   TABLE DATA           S   COPY hr.department (uuid, department, created_at, updated_at, remarks) FROM stdin;
    hr          postgres    false    255   ��      �          0    304864    designation 
   TABLE DATA           U   COPY hr.designation (uuid, designation, created_at, updated_at, remarks) FROM stdin;
    hr          postgres    false    256   �      �          0    304869    policy_and_notice 
   TABLE DATA              COPY hr.policy_and_notice (uuid, type, title, sub_title, url, created_at, updated_at, status, remarks, created_by) FROM stdin;
    hr          postgres    false    257   ��      r          0    304717    users 
   TABLE DATA           �   COPY hr.users (uuid, name, email, pass, designation_uuid, can_access, ext, phone, created_at, updated_at, status, remarks, department_uuid) FROM stdin;
    hr          postgres    false    237   ��      �          0    304874    info 
   TABLE DATA           �   COPY lab_dip.info (uuid, id, name, order_info_uuid, created_by, created_at, updated_at, remarks, lab_status, thread_order_info_uuid) FROM stdin;
    lab_dip          postgres    false    258   ��      �          0    304881    recipe 
   TABLE DATA           �   COPY lab_dip.recipe (uuid, id, lab_dip_info_uuid, name, approved, created_by, status, created_at, updated_at, remarks, sub_streat, bleaching) FROM stdin;
    lab_dip          postgres    false    260   0�      �          0    304888    recipe_entry 
   TABLE DATA           {   COPY lab_dip.recipe_entry (uuid, recipe_uuid, color, quantity, created_at, updated_at, remarks, material_uuid) FROM stdin;
    lab_dip          postgres    false    261   ��      �          0    304895    shade_recipe 
   TABLE DATA           �   COPY lab_dip.shade_recipe (uuid, id, name, sub_streat, lab_status, created_by, created_at, updated_at, remarks, bleaching) FROM stdin;
    lab_dip          postgres    false    264   >�      �          0    304902    shade_recipe_entry 
   TABLE DATA           �   COPY lab_dip.shade_recipe_entry (uuid, shade_recipe_uuid, material_uuid, quantity, created_at, updated_at, remarks) FROM stdin;
    lab_dip          postgres    false    265   [�      �          0    304907    info 
   TABLE DATA           �   COPY material.info (uuid, section_uuid, type_uuid, name, short_name, unit, threshold, description, created_at, updated_at, remarks, created_by, average_lead_time) FROM stdin;
    material          postgres    false    266   x�      �          0    304914    section 
   TABLE DATA           h   COPY material.section (uuid, name, short_name, remarks, created_at, updated_at, created_by) FROM stdin;
    material          postgres    false    267   ��      �          0    304919    stock 
   TABLE DATA           �  COPY material.stock (uuid, material_uuid, stock, tape_making, coil_forming, dying_and_iron, m_gapping, v_gapping, v_teeth_molding, m_teeth_molding, teeth_assembling_and_polishing, m_teeth_cleaning, v_teeth_cleaning, plating_and_iron, m_sealing, v_sealing, n_t_cutting, v_t_cutting, m_stopper, v_stopper, n_stopper, cutting, die_casting, slider_assembly, coloring, remarks, lab_dip, m_qc_and_packing, v_qc_and_packing, n_qc_and_packing, s_qc_and_packing) FROM stdin;
    material          postgres    false    268   ��      �          0    304952    stock_to_sfg 
   TABLE DATA           �   COPY material.stock_to_sfg (uuid, material_uuid, order_entry_uuid, trx_to, trx_quantity, created_by, created_at, updated_at, remarks) FROM stdin;
    material          postgres    false    269   ��      �          0    304957    trx 
   TABLE DATA           w   COPY material.trx (uuid, material_uuid, trx_to, trx_quantity, created_by, created_at, updated_at, remarks) FROM stdin;
    material          postgres    false    270   ��      �          0    304962    type 
   TABLE DATA           e   COPY material.type (uuid, name, short_name, remarks, created_at, updated_at, created_by) FROM stdin;
    material          postgres    false    271   ��      �          0    304967    used 
   TABLE DATA           �   COPY material.used (uuid, material_uuid, section, used_quantity, wastage, created_by, created_at, updated_at, remarks) FROM stdin;
    material          postgres    false    272   Z�      s          0    304723    buyer 
   TABLE DATA           d   COPY public.buyer (uuid, name, short_name, remarks, created_at, updated_at, created_by) FROM stdin;
    public          postgres    false    238   �      t          0    304728    factory 
   TABLE DATA           v   COPY public.factory (uuid, party_uuid, name, phone, address, created_at, updated_at, created_by, remarks) FROM stdin;
    public          postgres    false    239   7      �          0    304973    machine 
   TABLE DATA           �   COPY public.machine (uuid, name, is_vislon, is_metal, is_nylon, is_sewing_thread, is_bulk, is_sample, min_capacity, max_capacity, water_capacity, created_by, created_at, updated_at, remarks) FROM stdin;
    public          postgres    false    273   cw      u          0    304733 	   marketing 
   TABLE DATA           s   COPY public.marketing (uuid, name, short_name, user_uuid, remarks, created_at, updated_at, created_by) FROM stdin;
    public          postgres    false    240   1{      v          0    304738    merchandiser 
   TABLE DATA           �   COPY public.merchandiser (uuid, party_uuid, name, email, phone, address, created_at, updated_at, created_by, remarks) FROM stdin;
    public          postgres    false    241   �      w          0    304743    party 
   TABLE DATA           m   COPY public.party (uuid, name, short_name, remarks, created_at, updated_at, created_by, address) FROM stdin;
    public          postgres    false    242   e�      x          0    304748 
   properties 
   TABLE DATA           y   COPY public.properties (uuid, item_for, type, name, short_name, created_by, created_at, updated_at, remarks) FROM stdin;
    public          postgres    false    243   ;      �          0    304985    section 
   TABLE DATA           B   COPY public.section (uuid, name, short_name, remarks) FROM stdin;
    public          postgres    false    274   .      �          0    304991    description 
   TABLE DATA           �   COPY purchase.description (uuid, vendor_uuid, is_local, lc_number, created_by, created_at, updated_at, remarks, id, challan_number) FROM stdin;
    purchase          postgres    false    276   K      �          0    304997    entry 
   TABLE DATA           �   COPY purchase.entry (uuid, purchase_description_uuid, material_uuid, quantity, price, created_at, updated_at, remarks) FROM stdin;
    purchase          postgres    false    277   �      �          0    305003    vendor 
   TABLE DATA           �   COPY purchase.vendor (uuid, name, contact_name, email, office_address, contact_number, remarks, created_at, updated_at, created_by) FROM stdin;
    purchase          postgres    false    278   s      �          0    305008    assembly_stock 
   TABLE DATA           �   COPY slider.assembly_stock (uuid, name, die_casting_body_uuid, die_casting_puller_uuid, die_casting_cap_uuid, die_casting_link_uuid, quantity, created_by, created_at, updated_at, remarks, weight) FROM stdin;
    slider          postgres    false    279   �      �          0    305015    coloring_transaction 
   TABLE DATA           �   COPY slider.coloring_transaction (uuid, stock_uuid, order_info_uuid, trx_quantity, created_by, created_at, updated_at, remarks, weight) FROM stdin;
    slider          postgres    false    280   �      �          0    305021    die_casting 
   TABLE DATA             COPY slider.die_casting (uuid, name, item, zipper_number, end_type, puller_type, logo_type, slider_body_shape, slider_link, quantity, weight, pcs_per_kg, created_at, updated_at, remarks, quantity_in_sa, is_logo_body, is_logo_puller, type, created_by) FROM stdin;
    slider          postgres    false    281   �      �          0    305032    die_casting_production 
   TABLE DATA           �   COPY slider.die_casting_production (uuid, die_casting_uuid, mc_no, cavity_goods, cavity_defect, push, weight, order_description_uuid, created_by, created_at, updated_at, remarks) FROM stdin;
    slider          postgres    false    282   �      �          0    305037    die_casting_to_assembly_stock 
   TABLE DATA           �   COPY slider.die_casting_to_assembly_stock (uuid, assembly_stock_uuid, production_quantity, wastage, created_by, created_at, updated_at, remarks, with_link, weight) FROM stdin;
    slider          postgres    false    283   �      �          0    305046    die_casting_transaction 
   TABLE DATA           �   COPY slider.die_casting_transaction (uuid, die_casting_uuid, stock_uuid, trx_quantity, created_by, created_at, updated_at, remarks, weight) FROM stdin;
    slider          postgres    false    284   ?      �          0    305052 
   production 
   TABLE DATA           �   COPY slider.production (uuid, stock_uuid, production_quantity, wastage, section, created_by, created_at, updated_at, remarks, with_link, weight) FROM stdin;
    slider          postgres    false    285   \      y          0    304753    stock 
   TABLE DATA           Q  COPY slider.stock (uuid, order_quantity, body_quantity, cap_quantity, puller_quantity, link_quantity, sa_prod, coloring_stock, coloring_prod, trx_to_finishing, u_top_quantity, h_bottom_quantity, box_pin_quantity, two_way_pin_quantity, created_at, updated_at, remarks, quantity_in_sa, order_description_uuid, finishing_stock) FROM stdin;
    slider          postgres    false    244   �      �          0    305059    transaction 
   TABLE DATA           �   COPY slider.transaction (uuid, stock_uuid, trx_quantity, created_by, created_at, updated_at, remarks, from_section, to_section, assembly_stock_uuid, weight) FROM stdin;
    slider          postgres    false    286   �$      �          0    305065    trx_against_stock 
   TABLE DATA           �   COPY slider.trx_against_stock (uuid, die_casting_uuid, quantity, created_by, created_at, updated_at, remarks, weight) FROM stdin;
    slider          postgres    false    287   �%      �          0    305072    batch 
   TABLE DATA             COPY thread.batch (uuid, id, dyeing_operator, reason, category, status, pass_by, shift, dyeing_supervisor, coning_operator, coning_supervisor, coning_machines, created_by, created_at, updated_at, remarks, yarn_quantity, machine_uuid, lab_created_by, lab_created_at, lab_updated_at, yarn_issue_created_by, yarn_issue_created_at, yarn_issue_updated_at, is_drying_complete, drying_created_at, drying_updated_at, dyeing_created_by, dyeing_created_at, dyeing_updated_at, coning_created_by, coning_created_at, coning_updated_at, slot) FROM stdin;
    thread          postgres    false    289   u&      �          0    305080    batch_entry 
   TABLE DATA           
  COPY thread.batch_entry (uuid, batch_uuid, order_entry_uuid, quantity, coning_production_quantity, coning_carton_quantity, created_at, updated_at, remarks, coning_created_at, coning_updated_at, transfer_quantity, transfer_carton_quantity, yarn_quantity) FROM stdin;
    thread          postgres    false    290   '      �          0    305091    batch_entry_production 
   TABLE DATA           �   COPY thread.batch_entry_production (uuid, batch_entry_uuid, production_quantity, coning_carton_quantity, created_by, created_at, updated_at, remarks) FROM stdin;
    thread          postgres    false    291   �'      �          0    305096    batch_entry_trx 
   TABLE DATA           �   COPY thread.batch_entry_trx (uuid, batch_entry_uuid, quantity, created_by, created_at, updated_at, remarks, carton_quantity) FROM stdin;
    thread          postgres    false    292   �'      �          0    305103    challan 
   TABLE DATA           �   COPY thread.challan (uuid, order_info_uuid, carton_quantity, created_by, created_at, updated_at, remarks, assign_to, gate_pass, received, id) FROM stdin;
    thread          postgres    false    294   ](      �          0    305111    challan_entry 
   TABLE DATA           �   COPY thread.challan_entry (uuid, challan_uuid, order_entry_uuid, quantity, created_by, created_at, updated_at, remarks, short_quantity, reject_quantity) FROM stdin;
    thread          postgres    false    295   z(      �          0    305118    count_length 
   TABLE DATA           �   COPY thread.count_length (uuid, count, sst, created_by, created_at, updated_at, remarks, min_weight, max_weight, length, price, cone_per_carton) FROM stdin;
    thread          postgres    false    296   �(      �          0    305124    dyes_category 
   TABLE DATA           �   COPY thread.dyes_category (uuid, name, upto_percentage, bleaching, id, created_by, created_at, updated_at, remarks) FROM stdin;
    thread          postgres    false    297   �+      �          0    305131    order_entry 
   TABLE DATA           �  COPY thread.order_entry (uuid, order_info_uuid, lab_reference, color, po, style, count_length_uuid, quantity, company_price, party_price, swatch_approval_date, production_quantity, created_by, created_at, updated_at, remarks, bleaching, transfer_quantity, recipe_uuid, pi, delivered, warehouse, short_quantity, reject_quantity, production_quantity_in_kg, carton_quantity) FROM stdin;
    thread          postgres    false    298   
-      �          0    305148 
   order_info 
   TABLE DATA           �   COPY thread.order_info (uuid, id, party_uuid, marketing_uuid, factory_uuid, merchandiser_uuid, buyer_uuid, is_sample, is_bill, delivery_date, created_by, created_at, updated_at, remarks, is_cash) FROM stdin;
    thread          postgres    false    300   �6      �          0    305157    programs 
   TABLE DATA           �   COPY thread.programs (uuid, dyes_category_uuid, material_uuid, quantity, created_by, created_at, updated_at, remarks) FROM stdin;
    thread          postgres    false    301   -:      �          0    305163    batch 
   TABLE DATA           �   COPY zipper.batch (uuid, id, created_by, created_at, updated_at, remarks, batch_status, machine_uuid, slot, received) FROM stdin;
    zipper          postgres    false    302   �;      �          0    305171    batch_entry 
   TABLE DATA           �   COPY zipper.batch_entry (uuid, batch_uuid, quantity, production_quantity, production_quantity_in_kg, created_at, updated_at, remarks, sfg_uuid) FROM stdin;
    zipper          postgres    false    303   /<      �          0    305180    batch_production 
   TABLE DATA           �   COPY zipper.batch_production (uuid, batch_entry_uuid, production_quantity, production_quantity_in_kg, created_by, created_at, updated_at, remarks) FROM stdin;
    zipper          postgres    false    305   >=      �          0    305185    dyed_tape_transaction 
   TABLE DATA           �   COPY zipper.dyed_tape_transaction (uuid, order_description_uuid, colors, trx_quantity, created_by, created_at, updated_at, remarks) FROM stdin;
    zipper          postgres    false    306   [=      �          0    305190     dyed_tape_transaction_from_stock 
   TABLE DATA           �   COPY zipper.dyed_tape_transaction_from_stock (uuid, order_description_uuid, trx_quantity, tape_coil_uuid, created_by, created_at, updated_at, remarks) FROM stdin;
    zipper          postgres    false    307   �=      �          0    305196    dying_batch 
   TABLE DATA           c   COPY zipper.dying_batch (uuid, id, mc_no, created_by, created_at, updated_at, remarks) FROM stdin;
    zipper          postgres    false    308   �=      �          0    305201    dying_batch_entry 
   TABLE DATA           �   COPY zipper.dying_batch_entry (uuid, dying_batch_uuid, batch_entry_uuid, quantity, production_quantity, production_quantity_in_kg, created_at, updated_at, remarks) FROM stdin;
    zipper          postgres    false    309   >      �          0    305207 &   material_trx_against_order_description 
   TABLE DATA           �   COPY zipper.material_trx_against_order_description (uuid, order_description_uuid, material_uuid, trx_to, trx_quantity, created_by, created_at, updated_at, remarks) FROM stdin;
    zipper          postgres    false    311    >      �          0    305212    multi_color_dashboard 
   TABLE DATA           �   COPY zipper.multi_color_dashboard (uuid, order_description_uuid, expected_tape_quantity, is_swatch_approved, tape_quantity, coil_uuid, coil_quantity, thread_name, thread_quantity, is_coil_received_sewing, is_thread_received_sewing, remarks) FROM stdin;
    zipper          postgres    false    312   =>      �          0    305224    multi_color_tape_receive 
   TABLE DATA           �   COPY zipper.multi_color_tape_receive (uuid, order_description_uuid, quantity, created_by, created_at, updated_at, remarks) FROM stdin;
    zipper          postgres    false    313   �>      z          0    304773    order_description 
   TABLE DATA           �  COPY zipper.order_description (uuid, order_info_uuid, item, zipper_number, end_type, lock_type, puller_type, teeth_color, puller_color, special_requirement, hand, coloring_type, is_slider_provided, slider, slider_starting_section_enum, top_stopper, bottom_stopper, logo_type, is_logo_body, is_logo_puller, description, status, created_at, updated_at, remarks, slider_body_shape, slider_link, end_user, garment, light_preference, garments_wash, created_by, garments_remarks, tape_received, tape_transferred, slider_finishing_stock, nylon_stopper, tape_coil_uuid, teeth_type, is_inch, order_type, is_meter, is_cm, is_multi_color) FROM stdin;
    zipper          postgres    false    245   !?      {          0    304790    order_entry 
   TABLE DATA           �   COPY zipper.order_entry (uuid, order_description_uuid, style, color, size, quantity, company_price, party_price, status, swatch_status_enum, swatch_approval_date, created_at, updated_at, remarks, bleaching, is_inch) FROM stdin;
    zipper          postgres    false    246   qK      }          0    304801 
   order_info 
   TABLE DATA           %  COPY zipper.order_info (uuid, id, reference_order_info_uuid, buyer_uuid, party_uuid, marketing_uuid, merchandiser_uuid, factory_uuid, is_sample, is_bill, is_cash, marketing_priority, factory_priority, status, created_by, created_at, updated_at, remarks, conversion_rate, print_in) FROM stdin;
    zipper          postgres    false    248   �{      �          0    305229    planning 
   TABLE DATA           U   COPY zipper.planning (week, created_by, created_at, updated_at, remarks) FROM stdin;
    zipper          postgres    false    314   Ճ      �          0    305234    planning_entry 
   TABLE DATA           �   COPY zipper.planning_entry (uuid, sfg_uuid, sno_quantity, factory_quantity, production_quantity, batch_production_quantity, created_at, updated_at, planning_week, sno_remarks, factory_remarks) FROM stdin;
    zipper          postgres    false    315   �      ~          0    304813    sfg 
   TABLE DATA             COPY zipper.sfg (uuid, order_entry_uuid, recipe_uuid, dying_and_iron_prod, teeth_molding_stock, teeth_molding_prod, teeth_coloring_stock, teeth_coloring_prod, finishing_stock, finishing_prod, coloring_prod, warehouse, delivered, pi, remarks, short_quantity, reject_quantity) FROM stdin;
    zipper          postgres    false    249   �      �          0    305243    sfg_production 
   TABLE DATA           �   COPY zipper.sfg_production (uuid, sfg_uuid, section, production_quantity_in_kg, production_quantity, wastage, created_by, created_at, updated_at, remarks) FROM stdin;
    zipper          postgres    false    316   ;�      �          0    305251    sfg_transaction 
   TABLE DATA           �   COPY zipper.sfg_transaction (uuid, trx_from, trx_to, trx_quantity, slider_item_uuid, created_by, created_at, updated_at, remarks, sfg_uuid, trx_quantity_in_kg) FROM stdin;
    zipper          postgres    false    317   X�                0    304831 	   tape_coil 
   TABLE DATA             COPY zipper.tape_coil (uuid, quantity, trx_quantity_in_coil, quantity_in_coil, remarks, item_uuid, zipper_number_uuid, name, raw_per_kg_meter, dyed_per_kg_meter, created_by, created_at, updated_at, is_import, is_reverse, trx_quantity_in_dying, stock_quantity) FROM stdin;
    zipper          postgres    false    250   u�      �          0    305258    tape_coil_production 
   TABLE DATA           �   COPY zipper.tape_coil_production (uuid, section, tape_coil_uuid, production_quantity, wastage, created_by, created_at, updated_at, remarks) FROM stdin;
    zipper          postgres    false    318   ۩      �          0    305264    tape_coil_required 
   TABLE DATA           �   COPY zipper.tape_coil_required (uuid, end_type_uuid, item_uuid, nylon_stopper_uuid, zipper_number_uuid, top, bottom, created_by, created_at, updated_at, remarks) FROM stdin;
    zipper          postgres    false    319   ��      �          0    305269    tape_coil_to_dyeing 
   TABLE DATA           �   COPY zipper.tape_coil_to_dyeing (uuid, tape_coil_uuid, order_description_uuid, trx_quantity, created_by, created_at, updated_at, remarks, is_received_in_sewing) FROM stdin;
    zipper          postgres    false    320   %�      �          0    305275    tape_trx 
   TABLE DATA              COPY zipper.tape_trx (uuid, tape_coil_uuid, trx_quantity, created_by, created_at, updated_at, remarks, to_section) FROM stdin;
    zipper          postgres    false    321   ޮ      �           0    0    lc_sequence    SEQUENCE SET     =   SELECT pg_catalog.setval('commercial.lc_sequence', 3, true);
       
   commercial          postgres    false    226            �           0    0    pi_sequence    SEQUENCE SET     >   SELECT pg_catalog.setval('commercial.pi_sequence', 13, true);
       
   commercial          postgres    false    228            �           0    0    challan_sequence    SEQUENCE SET     @   SELECT pg_catalog.setval('delivery.challan_sequence', 1, true);
          delivery          postgres    false    231            �           0    0    packing_list_sequence    SEQUENCE SET     E   SELECT pg_catalog.setval('delivery.packing_list_sequence', 9, true);
          delivery          postgres    false    234            �           0    0    migrations_details_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('drizzle.migrations_details_id_seq', 145, true);
          drizzle          postgres    false    254            �           0    0    info_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('lab_dip.info_id_seq', 26, true);
          lab_dip          postgres    false    259            �           0    0    recipe_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('lab_dip.recipe_id_seq', 44, true);
          lab_dip          postgres    false    262            �           0    0    shade_recipe_sequence    SEQUENCE SET     D   SELECT pg_catalog.setval('lab_dip.shade_recipe_sequence', 1, true);
          lab_dip          postgres    false    263            �           0    0    purchase_description_sequence    SEQUENCE SET     M   SELECT pg_catalog.setval('purchase.purchase_description_sequence', 2, true);
          purchase          postgres    false    275            �           0    0    thread_batch_sequence    SEQUENCE SET     C   SELECT pg_catalog.setval('thread.thread_batch_sequence', 2, true);
          thread          postgres    false    288            �           0    0    thread_challan_sequence    SEQUENCE SET     F   SELECT pg_catalog.setval('thread.thread_challan_sequence', 1, false);
          thread          postgres    false    293            �           0    0    thread_order_info_sequence    SEQUENCE SET     I   SELECT pg_catalog.setval('thread.thread_order_info_sequence', 11, true);
          thread          postgres    false    299            �           0    0    batch_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('zipper.batch_id_seq', 2, true);
          zipper          postgres    false    304            �           0    0    dying_batch_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('zipper.dying_batch_id_seq', 1, false);
          zipper          postgres    false    310            �           0    0    order_info_sequence    SEQUENCE SET     B   SELECT pg_catalog.setval('zipper.order_info_sequence', 28, true);
          zipper          postgres    false    247            �           2606    305291    bank bank_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY commercial.bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (uuid);
 <   ALTER TABLE ONLY commercial.bank DROP CONSTRAINT bank_pkey;
    
   commercial            postgres    false    225            �           2606    305293 
   lc lc_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY commercial.lc
    ADD CONSTRAINT lc_pkey PRIMARY KEY (uuid);
 8   ALTER TABLE ONLY commercial.lc DROP CONSTRAINT lc_pkey;
    
   commercial            postgres    false    227            �           2606    305295     pi_cash_entry pi_cash_entry_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY commercial.pi_cash_entry
    ADD CONSTRAINT pi_cash_entry_pkey PRIMARY KEY (uuid);
 N   ALTER TABLE ONLY commercial.pi_cash_entry DROP CONSTRAINT pi_cash_entry_pkey;
    
   commercial            postgres    false    230            �           2606    305297    pi_cash pi_cash_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY commercial.pi_cash
    ADD CONSTRAINT pi_cash_pkey PRIMARY KEY (uuid);
 B   ALTER TABLE ONLY commercial.pi_cash DROP CONSTRAINT pi_cash_pkey;
    
   commercial            postgres    false    229                       2606    305299     challan_entry challan_entry_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY delivery.challan_entry
    ADD CONSTRAINT challan_entry_pkey PRIMARY KEY (uuid);
 L   ALTER TABLE ONLY delivery.challan_entry DROP CONSTRAINT challan_entry_pkey;
       delivery            postgres    false    233            �           2606    305301    challan challan_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY delivery.challan
    ADD CONSTRAINT challan_pkey PRIMARY KEY (uuid);
 @   ALTER TABLE ONLY delivery.challan DROP CONSTRAINT challan_pkey;
       delivery            postgres    false    232                       2606    305303 *   packing_list_entry packing_list_entry_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY delivery.packing_list_entry
    ADD CONSTRAINT packing_list_entry_pkey PRIMARY KEY (uuid);
 V   ALTER TABLE ONLY delivery.packing_list_entry DROP CONSTRAINT packing_list_entry_pkey;
       delivery            postgres    false    236                       2606    305305    packing_list packing_list_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY delivery.packing_list
    ADD CONSTRAINT packing_list_pkey PRIMARY KEY (uuid);
 J   ALTER TABLE ONLY delivery.packing_list DROP CONSTRAINT packing_list_pkey;
       delivery            postgres    false    235            -           2606    305307 *   migrations_details migrations_details_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY drizzle.migrations_details
    ADD CONSTRAINT migrations_details_pkey PRIMARY KEY (id);
 U   ALTER TABLE ONLY drizzle.migrations_details DROP CONSTRAINT migrations_details_pkey;
       drizzle            postgres    false    253            /           2606    305309 '   department department_department_unique 
   CONSTRAINT     d   ALTER TABLE ONLY hr.department
    ADD CONSTRAINT department_department_unique UNIQUE (department);
 M   ALTER TABLE ONLY hr.department DROP CONSTRAINT department_department_unique;
       hr            postgres    false    255            1           2606    305311    department department_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY hr.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (uuid);
 @   ALTER TABLE ONLY hr.department DROP CONSTRAINT department_pkey;
       hr            postgres    false    255            3           2606    305313    department department_unique 
   CONSTRAINT     Y   ALTER TABLE ONLY hr.department
    ADD CONSTRAINT department_unique UNIQUE (department);
 B   ALTER TABLE ONLY hr.department DROP CONSTRAINT department_unique;
       hr            postgres    false    255            5           2606    305315 *   designation designation_designation_unique 
   CONSTRAINT     h   ALTER TABLE ONLY hr.designation
    ADD CONSTRAINT designation_designation_unique UNIQUE (designation);
 P   ALTER TABLE ONLY hr.designation DROP CONSTRAINT designation_designation_unique;
       hr            postgres    false    256            7           2606    305317    designation designation_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY hr.designation
    ADD CONSTRAINT designation_pkey PRIMARY KEY (uuid);
 B   ALTER TABLE ONLY hr.designation DROP CONSTRAINT designation_pkey;
       hr            postgres    false    256            9           2606    305319    designation designation_unique 
   CONSTRAINT     \   ALTER TABLE ONLY hr.designation
    ADD CONSTRAINT designation_unique UNIQUE (designation);
 D   ALTER TABLE ONLY hr.designation DROP CONSTRAINT designation_unique;
       hr            postgres    false    256            ;           2606    305321 (   policy_and_notice policy_and_notice_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY hr.policy_and_notice
    ADD CONSTRAINT policy_and_notice_pkey PRIMARY KEY (uuid);
 N   ALTER TABLE ONLY hr.policy_and_notice DROP CONSTRAINT policy_and_notice_pkey;
       hr            postgres    false    257                       2606    305323    users users_email_unique 
   CONSTRAINT     P   ALTER TABLE ONLY hr.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 >   ALTER TABLE ONLY hr.users DROP CONSTRAINT users_email_unique;
       hr            postgres    false    237            	           2606    305325    users users_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY hr.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uuid);
 6   ALTER TABLE ONLY hr.users DROP CONSTRAINT users_pkey;
       hr            postgres    false    237            =           2606    305327    info info_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY lab_dip.info
    ADD CONSTRAINT info_pkey PRIMARY KEY (uuid);
 9   ALTER TABLE ONLY lab_dip.info DROP CONSTRAINT info_pkey;
       lab_dip            postgres    false    258            A           2606    305329    recipe_entry recipe_entry_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY lab_dip.recipe_entry
    ADD CONSTRAINT recipe_entry_pkey PRIMARY KEY (uuid);
 I   ALTER TABLE ONLY lab_dip.recipe_entry DROP CONSTRAINT recipe_entry_pkey;
       lab_dip            postgres    false    261            ?           2606    305331    recipe recipe_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY lab_dip.recipe
    ADD CONSTRAINT recipe_pkey PRIMARY KEY (uuid);
 =   ALTER TABLE ONLY lab_dip.recipe DROP CONSTRAINT recipe_pkey;
       lab_dip            postgres    false    260            E           2606    305333 *   shade_recipe_entry shade_recipe_entry_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY lab_dip.shade_recipe_entry
    ADD CONSTRAINT shade_recipe_entry_pkey PRIMARY KEY (uuid);
 U   ALTER TABLE ONLY lab_dip.shade_recipe_entry DROP CONSTRAINT shade_recipe_entry_pkey;
       lab_dip            postgres    false    265            C           2606    305335    shade_recipe shade_recipe_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY lab_dip.shade_recipe
    ADD CONSTRAINT shade_recipe_pkey PRIMARY KEY (uuid);
 I   ALTER TABLE ONLY lab_dip.shade_recipe DROP CONSTRAINT shade_recipe_pkey;
       lab_dip            postgres    false    264            G           2606    305337    info info_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY material.info
    ADD CONSTRAINT info_pkey PRIMARY KEY (uuid);
 :   ALTER TABLE ONLY material.info DROP CONSTRAINT info_pkey;
       material            postgres    false    266            I           2606    305339    section section_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY material.section
    ADD CONSTRAINT section_pkey PRIMARY KEY (uuid);
 @   ALTER TABLE ONLY material.section DROP CONSTRAINT section_pkey;
       material            postgres    false    267            K           2606    305341    stock stock_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY material.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (uuid);
 <   ALTER TABLE ONLY material.stock DROP CONSTRAINT stock_pkey;
       material            postgres    false    268            M           2606    305343    stock_to_sfg stock_to_sfg_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY material.stock_to_sfg
    ADD CONSTRAINT stock_to_sfg_pkey PRIMARY KEY (uuid);
 J   ALTER TABLE ONLY material.stock_to_sfg DROP CONSTRAINT stock_to_sfg_pkey;
       material            postgres    false    269            O           2606    305345    trx trx_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY material.trx
    ADD CONSTRAINT trx_pkey PRIMARY KEY (uuid);
 8   ALTER TABLE ONLY material.trx DROP CONSTRAINT trx_pkey;
       material            postgres    false    270            Q           2606    305347    type type_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY material.type
    ADD CONSTRAINT type_pkey PRIMARY KEY (uuid);
 :   ALTER TABLE ONLY material.type DROP CONSTRAINT type_pkey;
       material            postgres    false    271            S           2606    305349    used used_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY material.used
    ADD CONSTRAINT used_pkey PRIMARY KEY (uuid);
 :   ALTER TABLE ONLY material.used DROP CONSTRAINT used_pkey;
       material            postgres    false    272                       2606    305351    buyer buyer_name_unique 
   CONSTRAINT     R   ALTER TABLE ONLY public.buyer
    ADD CONSTRAINT buyer_name_unique UNIQUE (name);
 A   ALTER TABLE ONLY public.buyer DROP CONSTRAINT buyer_name_unique;
       public            postgres    false    238                       2606    305353    buyer buyer_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.buyer
    ADD CONSTRAINT buyer_pkey PRIMARY KEY (uuid);
 :   ALTER TABLE ONLY public.buyer DROP CONSTRAINT buyer_pkey;
       public            postgres    false    238                       2606    305355    factory factory_name_unique 
   CONSTRAINT     V   ALTER TABLE ONLY public.factory
    ADD CONSTRAINT factory_name_unique UNIQUE (name);
 E   ALTER TABLE ONLY public.factory DROP CONSTRAINT factory_name_unique;
       public            postgres    false    239                       2606    305357    factory factory_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.factory
    ADD CONSTRAINT factory_pkey PRIMARY KEY (uuid);
 >   ALTER TABLE ONLY public.factory DROP CONSTRAINT factory_pkey;
       public            postgres    false    239            U           2606    305359    machine machine_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.machine
    ADD CONSTRAINT machine_pkey PRIMARY KEY (uuid);
 >   ALTER TABLE ONLY public.machine DROP CONSTRAINT machine_pkey;
       public            postgres    false    273                       2606    305361    marketing marketing_name_unique 
   CONSTRAINT     Z   ALTER TABLE ONLY public.marketing
    ADD CONSTRAINT marketing_name_unique UNIQUE (name);
 I   ALTER TABLE ONLY public.marketing DROP CONSTRAINT marketing_name_unique;
       public            postgres    false    240                       2606    305363    marketing marketing_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.marketing
    ADD CONSTRAINT marketing_pkey PRIMARY KEY (uuid);
 B   ALTER TABLE ONLY public.marketing DROP CONSTRAINT marketing_pkey;
       public            postgres    false    240                       2606    305365 %   merchandiser merchandiser_name_unique 
   CONSTRAINT     `   ALTER TABLE ONLY public.merchandiser
    ADD CONSTRAINT merchandiser_name_unique UNIQUE (name);
 O   ALTER TABLE ONLY public.merchandiser DROP CONSTRAINT merchandiser_name_unique;
       public            postgres    false    241                       2606    305367    merchandiser merchandiser_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.merchandiser
    ADD CONSTRAINT merchandiser_pkey PRIMARY KEY (uuid);
 H   ALTER TABLE ONLY public.merchandiser DROP CONSTRAINT merchandiser_pkey;
       public            postgres    false    241                       2606    305369    party party_name_unique 
   CONSTRAINT     R   ALTER TABLE ONLY public.party
    ADD CONSTRAINT party_name_unique UNIQUE (name);
 A   ALTER TABLE ONLY public.party DROP CONSTRAINT party_name_unique;
       public            postgres    false    242                       2606    305371    party party_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.party
    ADD CONSTRAINT party_pkey PRIMARY KEY (uuid);
 :   ALTER TABLE ONLY public.party DROP CONSTRAINT party_pkey;
       public            postgres    false    242                       2606    305373    properties properties_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (uuid);
 D   ALTER TABLE ONLY public.properties DROP CONSTRAINT properties_pkey;
       public            postgres    false    243            W           2606    305375    section section_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.section
    ADD CONSTRAINT section_pkey PRIMARY KEY (uuid);
 >   ALTER TABLE ONLY public.section DROP CONSTRAINT section_pkey;
       public            postgres    false    274            Y           2606    305377    description description_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY purchase.description
    ADD CONSTRAINT description_pkey PRIMARY KEY (uuid);
 H   ALTER TABLE ONLY purchase.description DROP CONSTRAINT description_pkey;
       purchase            postgres    false    276            [           2606    305379    entry entry_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY purchase.entry
    ADD CONSTRAINT entry_pkey PRIMARY KEY (uuid);
 <   ALTER TABLE ONLY purchase.entry DROP CONSTRAINT entry_pkey;
       purchase            postgres    false    277            ]           2606    305381    vendor vendor_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY purchase.vendor
    ADD CONSTRAINT vendor_pkey PRIMARY KEY (uuid);
 >   ALTER TABLE ONLY purchase.vendor DROP CONSTRAINT vendor_pkey;
       purchase            postgres    false    278            _           2606    305383 "   assembly_stock assembly_stock_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY slider.assembly_stock
    ADD CONSTRAINT assembly_stock_pkey PRIMARY KEY (uuid);
 L   ALTER TABLE ONLY slider.assembly_stock DROP CONSTRAINT assembly_stock_pkey;
       slider            postgres    false    279            a           2606    305385 .   coloring_transaction coloring_transaction_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY slider.coloring_transaction
    ADD CONSTRAINT coloring_transaction_pkey PRIMARY KEY (uuid);
 X   ALTER TABLE ONLY slider.coloring_transaction DROP CONSTRAINT coloring_transaction_pkey;
       slider            postgres    false    280            c           2606    305387    die_casting die_casting_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY slider.die_casting
    ADD CONSTRAINT die_casting_pkey PRIMARY KEY (uuid);
 F   ALTER TABLE ONLY slider.die_casting DROP CONSTRAINT die_casting_pkey;
       slider            postgres    false    281            e           2606    305389 2   die_casting_production die_casting_production_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY slider.die_casting_production
    ADD CONSTRAINT die_casting_production_pkey PRIMARY KEY (uuid);
 \   ALTER TABLE ONLY slider.die_casting_production DROP CONSTRAINT die_casting_production_pkey;
       slider            postgres    false    282            g           2606    305391 @   die_casting_to_assembly_stock die_casting_to_assembly_stock_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting_to_assembly_stock
    ADD CONSTRAINT die_casting_to_assembly_stock_pkey PRIMARY KEY (uuid);
 j   ALTER TABLE ONLY slider.die_casting_to_assembly_stock DROP CONSTRAINT die_casting_to_assembly_stock_pkey;
       slider            postgres    false    283            i           2606    305393 4   die_casting_transaction die_casting_transaction_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY slider.die_casting_transaction
    ADD CONSTRAINT die_casting_transaction_pkey PRIMARY KEY (uuid);
 ^   ALTER TABLE ONLY slider.die_casting_transaction DROP CONSTRAINT die_casting_transaction_pkey;
       slider            postgres    false    284            k           2606    305395    production production_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY slider.production
    ADD CONSTRAINT production_pkey PRIMARY KEY (uuid);
 D   ALTER TABLE ONLY slider.production DROP CONSTRAINT production_pkey;
       slider            postgres    false    285            !           2606    305397    stock stock_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY slider.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (uuid);
 :   ALTER TABLE ONLY slider.stock DROP CONSTRAINT stock_pkey;
       slider            postgres    false    244            m           2606    305399    transaction transaction_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY slider.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (uuid);
 F   ALTER TABLE ONLY slider.transaction DROP CONSTRAINT transaction_pkey;
       slider            postgres    false    286            o           2606    305401 (   trx_against_stock trx_against_stock_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY slider.trx_against_stock
    ADD CONSTRAINT trx_against_stock_pkey PRIMARY KEY (uuid);
 R   ALTER TABLE ONLY slider.trx_against_stock DROP CONSTRAINT trx_against_stock_pkey;
       slider            postgres    false    287            s           2606    305403    batch_entry batch_entry_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY thread.batch_entry
    ADD CONSTRAINT batch_entry_pkey PRIMARY KEY (uuid);
 F   ALTER TABLE ONLY thread.batch_entry DROP CONSTRAINT batch_entry_pkey;
       thread            postgres    false    290            u           2606    305405 2   batch_entry_production batch_entry_production_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY thread.batch_entry_production
    ADD CONSTRAINT batch_entry_production_pkey PRIMARY KEY (uuid);
 \   ALTER TABLE ONLY thread.batch_entry_production DROP CONSTRAINT batch_entry_production_pkey;
       thread            postgres    false    291            w           2606    305407 $   batch_entry_trx batch_entry_trx_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY thread.batch_entry_trx
    ADD CONSTRAINT batch_entry_trx_pkey PRIMARY KEY (uuid);
 N   ALTER TABLE ONLY thread.batch_entry_trx DROP CONSTRAINT batch_entry_trx_pkey;
       thread            postgres    false    292            q           2606    305409    batch batch_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY thread.batch
    ADD CONSTRAINT batch_pkey PRIMARY KEY (uuid);
 :   ALTER TABLE ONLY thread.batch DROP CONSTRAINT batch_pkey;
       thread            postgres    false    289            {           2606    305411     challan_entry challan_entry_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY thread.challan_entry
    ADD CONSTRAINT challan_entry_pkey PRIMARY KEY (uuid);
 J   ALTER TABLE ONLY thread.challan_entry DROP CONSTRAINT challan_entry_pkey;
       thread            postgres    false    295            y           2606    305413    challan challan_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY thread.challan
    ADD CONSTRAINT challan_pkey PRIMARY KEY (uuid);
 >   ALTER TABLE ONLY thread.challan DROP CONSTRAINT challan_pkey;
       thread            postgres    false    294            }           2606    305415 !   count_length count_length_uuid_pk 
   CONSTRAINT     a   ALTER TABLE ONLY thread.count_length
    ADD CONSTRAINT count_length_uuid_pk PRIMARY KEY (uuid);
 K   ALTER TABLE ONLY thread.count_length DROP CONSTRAINT count_length_uuid_pk;
       thread            postgres    false    296                       2606    305417     dyes_category dyes_category_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY thread.dyes_category
    ADD CONSTRAINT dyes_category_pkey PRIMARY KEY (uuid);
 J   ALTER TABLE ONLY thread.dyes_category DROP CONSTRAINT dyes_category_pkey;
       thread            postgres    false    297            �           2606    305419    order_entry order_entry_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY thread.order_entry
    ADD CONSTRAINT order_entry_pkey PRIMARY KEY (uuid);
 F   ALTER TABLE ONLY thread.order_entry DROP CONSTRAINT order_entry_pkey;
       thread            postgres    false    298            �           2606    305421    order_info order_info_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY thread.order_info
    ADD CONSTRAINT order_info_pkey PRIMARY KEY (uuid);
 D   ALTER TABLE ONLY thread.order_info DROP CONSTRAINT order_info_pkey;
       thread            postgres    false    300            �           2606    305423    programs programs_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY thread.programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (uuid);
 @   ALTER TABLE ONLY thread.programs DROP CONSTRAINT programs_pkey;
       thread            postgres    false    301            �           2606    305425    batch_entry batch_entry_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY zipper.batch_entry
    ADD CONSTRAINT batch_entry_pkey PRIMARY KEY (uuid);
 F   ALTER TABLE ONLY zipper.batch_entry DROP CONSTRAINT batch_entry_pkey;
       zipper            postgres    false    303            �           2606    305427    batch batch_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY zipper.batch
    ADD CONSTRAINT batch_pkey PRIMARY KEY (uuid);
 :   ALTER TABLE ONLY zipper.batch DROP CONSTRAINT batch_pkey;
       zipper            postgres    false    302            �           2606    305429 &   batch_production batch_production_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY zipper.batch_production
    ADD CONSTRAINT batch_production_pkey PRIMARY KEY (uuid);
 P   ALTER TABLE ONLY zipper.batch_production DROP CONSTRAINT batch_production_pkey;
       zipper            postgres    false    305            �           2606    305431 F   dyed_tape_transaction_from_stock dyed_tape_transaction_from_stock_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY zipper.dyed_tape_transaction_from_stock
    ADD CONSTRAINT dyed_tape_transaction_from_stock_pkey PRIMARY KEY (uuid);
 p   ALTER TABLE ONLY zipper.dyed_tape_transaction_from_stock DROP CONSTRAINT dyed_tape_transaction_from_stock_pkey;
       zipper            postgres    false    307            �           2606    305433 0   dyed_tape_transaction dyed_tape_transaction_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY zipper.dyed_tape_transaction
    ADD CONSTRAINT dyed_tape_transaction_pkey PRIMARY KEY (uuid);
 Z   ALTER TABLE ONLY zipper.dyed_tape_transaction DROP CONSTRAINT dyed_tape_transaction_pkey;
       zipper            postgres    false    306            �           2606    305435 (   dying_batch_entry dying_batch_entry_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY zipper.dying_batch_entry
    ADD CONSTRAINT dying_batch_entry_pkey PRIMARY KEY (uuid);
 R   ALTER TABLE ONLY zipper.dying_batch_entry DROP CONSTRAINT dying_batch_entry_pkey;
       zipper            postgres    false    309            �           2606    305437    dying_batch dying_batch_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY zipper.dying_batch
    ADD CONSTRAINT dying_batch_pkey PRIMARY KEY (uuid);
 F   ALTER TABLE ONLY zipper.dying_batch DROP CONSTRAINT dying_batch_pkey;
       zipper            postgres    false    308            �           2606    305439 R   material_trx_against_order_description material_trx_against_order_description_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY zipper.material_trx_against_order_description
    ADD CONSTRAINT material_trx_against_order_description_pkey PRIMARY KEY (uuid);
 |   ALTER TABLE ONLY zipper.material_trx_against_order_description DROP CONSTRAINT material_trx_against_order_description_pkey;
       zipper            postgres    false    311            �           2606    305441 0   multi_color_dashboard multi_color_dashboard_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY zipper.multi_color_dashboard
    ADD CONSTRAINT multi_color_dashboard_pkey PRIMARY KEY (uuid);
 Z   ALTER TABLE ONLY zipper.multi_color_dashboard DROP CONSTRAINT multi_color_dashboard_pkey;
       zipper            postgres    false    312            �           2606    305443 6   multi_color_tape_receive multi_color_tape_receive_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY zipper.multi_color_tape_receive
    ADD CONSTRAINT multi_color_tape_receive_pkey PRIMARY KEY (uuid);
 `   ALTER TABLE ONLY zipper.multi_color_tape_receive DROP CONSTRAINT multi_color_tape_receive_pkey;
       zipper            postgres    false    313            #           2606    305445 (   order_description order_description_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_pkey PRIMARY KEY (uuid);
 R   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_pkey;
       zipper            postgres    false    245            %           2606    305447    order_entry order_entry_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY zipper.order_entry
    ADD CONSTRAINT order_entry_pkey PRIMARY KEY (uuid);
 F   ALTER TABLE ONLY zipper.order_entry DROP CONSTRAINT order_entry_pkey;
       zipper            postgres    false    246            '           2606    305449    order_info order_info_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY zipper.order_info
    ADD CONSTRAINT order_info_pkey PRIMARY KEY (uuid);
 D   ALTER TABLE ONLY zipper.order_info DROP CONSTRAINT order_info_pkey;
       zipper            postgres    false    248            �           2606    305451 "   planning_entry planning_entry_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY zipper.planning_entry
    ADD CONSTRAINT planning_entry_pkey PRIMARY KEY (uuid);
 L   ALTER TABLE ONLY zipper.planning_entry DROP CONSTRAINT planning_entry_pkey;
       zipper            postgres    false    315            �           2606    305453    planning planning_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY zipper.planning
    ADD CONSTRAINT planning_pkey PRIMARY KEY (week);
 @   ALTER TABLE ONLY zipper.planning DROP CONSTRAINT planning_pkey;
       zipper            postgres    false    314            )           2606    305455    sfg sfg_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY zipper.sfg
    ADD CONSTRAINT sfg_pkey PRIMARY KEY (uuid);
 6   ALTER TABLE ONLY zipper.sfg DROP CONSTRAINT sfg_pkey;
       zipper            postgres    false    249            �           2606    305457 "   sfg_production sfg_production_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY zipper.sfg_production
    ADD CONSTRAINT sfg_production_pkey PRIMARY KEY (uuid);
 L   ALTER TABLE ONLY zipper.sfg_production DROP CONSTRAINT sfg_production_pkey;
       zipper            postgres    false    316            �           2606    305459 $   sfg_transaction sfg_transaction_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY zipper.sfg_transaction
    ADD CONSTRAINT sfg_transaction_pkey PRIMARY KEY (uuid);
 N   ALTER TABLE ONLY zipper.sfg_transaction DROP CONSTRAINT sfg_transaction_pkey;
       zipper            postgres    false    317            +           2606    305461    tape_coil tape_coil_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY zipper.tape_coil
    ADD CONSTRAINT tape_coil_pkey PRIMARY KEY (uuid);
 B   ALTER TABLE ONLY zipper.tape_coil DROP CONSTRAINT tape_coil_pkey;
       zipper            postgres    false    250            �           2606    305463 .   tape_coil_production tape_coil_production_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY zipper.tape_coil_production
    ADD CONSTRAINT tape_coil_production_pkey PRIMARY KEY (uuid);
 X   ALTER TABLE ONLY zipper.tape_coil_production DROP CONSTRAINT tape_coil_production_pkey;
       zipper            postgres    false    318            �           2606    305465 *   tape_coil_required tape_coil_required_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY zipper.tape_coil_required
    ADD CONSTRAINT tape_coil_required_pkey PRIMARY KEY (uuid);
 T   ALTER TABLE ONLY zipper.tape_coil_required DROP CONSTRAINT tape_coil_required_pkey;
       zipper            postgres    false    319            �           2606    305467 ,   tape_coil_to_dyeing tape_coil_to_dyeing_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY zipper.tape_coil_to_dyeing
    ADD CONSTRAINT tape_coil_to_dyeing_pkey PRIMARY KEY (uuid);
 V   ALTER TABLE ONLY zipper.tape_coil_to_dyeing DROP CONSTRAINT tape_coil_to_dyeing_pkey;
       zipper            postgres    false    320            �           2606    305469    tape_trx tape_to_coil_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY zipper.tape_trx
    ADD CONSTRAINT tape_to_coil_pkey PRIMARY KEY (uuid);
 D   ALTER TABLE ONLY zipper.tape_trx DROP CONSTRAINT tape_to_coil_pkey;
       zipper            postgres    false    321            y           2620    305470 :   pi_cash_entry sfg_after_commercial_pi_entry_delete_trigger    TRIGGER     �   CREATE TRIGGER sfg_after_commercial_pi_entry_delete_trigger AFTER DELETE ON commercial.pi_cash_entry FOR EACH ROW EXECUTE FUNCTION commercial.sfg_after_commercial_pi_entry_delete_function();
 W   DROP TRIGGER sfg_after_commercial_pi_entry_delete_trigger ON commercial.pi_cash_entry;
    
   commercial          postgres    false    230    418            z           2620    305471 :   pi_cash_entry sfg_after_commercial_pi_entry_insert_trigger    TRIGGER     �   CREATE TRIGGER sfg_after_commercial_pi_entry_insert_trigger AFTER INSERT ON commercial.pi_cash_entry FOR EACH ROW EXECUTE FUNCTION commercial.sfg_after_commercial_pi_entry_insert_function();
 W   DROP TRIGGER sfg_after_commercial_pi_entry_insert_trigger ON commercial.pi_cash_entry;
    
   commercial          postgres    false    230    406            {           2620    305472 :   pi_cash_entry sfg_after_commercial_pi_entry_update_trigger    TRIGGER     �   CREATE TRIGGER sfg_after_commercial_pi_entry_update_trigger AFTER UPDATE ON commercial.pi_cash_entry FOR EACH ROW EXECUTE FUNCTION commercial.sfg_after_commercial_pi_entry_update_function();
 W   DROP TRIGGER sfg_after_commercial_pi_entry_update_trigger ON commercial.pi_cash_entry;
    
   commercial          postgres    false    230    352                       2620    305473 5   challan_entry packing_list_after_challan_entry_delete    TRIGGER     �   CREATE TRIGGER packing_list_after_challan_entry_delete AFTER DELETE ON delivery.challan_entry FOR EACH ROW EXECUTE FUNCTION delivery.packing_list_after_challan_entry_delete_function();
 P   DROP TRIGGER packing_list_after_challan_entry_delete ON delivery.challan_entry;
       delivery          postgres    false    233    429            �           2620    305474 5   challan_entry packing_list_after_challan_entry_insert    TRIGGER     �   CREATE TRIGGER packing_list_after_challan_entry_insert AFTER INSERT ON delivery.challan_entry FOR EACH ROW EXECUTE FUNCTION delivery.packing_list_after_challan_entry_insert_function();
 P   DROP TRIGGER packing_list_after_challan_entry_insert ON delivery.challan_entry;
       delivery          postgres    false    338    233            �           2620    305475 5   challan_entry packing_list_after_challan_entry_update    TRIGGER     �   CREATE TRIGGER packing_list_after_challan_entry_update AFTER UPDATE ON delivery.challan_entry FOR EACH ROW EXECUTE FUNCTION delivery.packing_list_after_challan_entry_update_function();
 P   DROP TRIGGER packing_list_after_challan_entry_update ON delivery.challan_entry;
       delivery          postgres    false    233    367            |           2620    305476 /   challan sfg_after_challan_receive_status_delete    TRIGGER     �   CREATE TRIGGER sfg_after_challan_receive_status_delete AFTER DELETE ON delivery.challan FOR EACH ROW EXECUTE FUNCTION delivery.sfg_after_challan_receive_status_delete_function();
 J   DROP TRIGGER sfg_after_challan_receive_status_delete ON delivery.challan;
       delivery          postgres    false    377    232            }           2620    305478 /   challan sfg_after_challan_receive_status_insert    TRIGGER     �   CREATE TRIGGER sfg_after_challan_receive_status_insert AFTER INSERT ON delivery.challan FOR EACH ROW EXECUTE FUNCTION delivery.sfg_after_challan_receive_status_insert_function();
 J   DROP TRIGGER sfg_after_challan_receive_status_insert ON delivery.challan;
       delivery          postgres    false    332    232            ~           2620    305480 /   challan sfg_after_challan_receive_status_update    TRIGGER     �   CREATE TRIGGER sfg_after_challan_receive_status_update AFTER UPDATE ON delivery.challan FOR EACH ROW EXECUTE FUNCTION delivery.sfg_after_challan_receive_status_update_function();
 J   DROP TRIGGER sfg_after_challan_receive_status_update ON delivery.challan;
       delivery          postgres    false    398    232            �           2620    305482 6   packing_list_entry sfg_after_packing_list_entry_delete    TRIGGER     �   CREATE TRIGGER sfg_after_packing_list_entry_delete AFTER DELETE ON delivery.packing_list_entry FOR EACH ROW EXECUTE FUNCTION delivery.sfg_after_packing_list_entry_delete_function();
 Q   DROP TRIGGER sfg_after_packing_list_entry_delete ON delivery.packing_list_entry;
       delivery          postgres    false    336    236            �           2620    305483 6   packing_list_entry sfg_after_packing_list_entry_insert    TRIGGER     �   CREATE TRIGGER sfg_after_packing_list_entry_insert AFTER INSERT ON delivery.packing_list_entry FOR EACH ROW EXECUTE FUNCTION delivery.sfg_after_packing_list_entry_insert_function();
 Q   DROP TRIGGER sfg_after_packing_list_entry_insert ON delivery.packing_list_entry;
       delivery          postgres    false    236    376            �           2620    305484 6   packing_list_entry sfg_after_packing_list_entry_update    TRIGGER     �   CREATE TRIGGER sfg_after_packing_list_entry_update AFTER UPDATE ON delivery.packing_list_entry FOR EACH ROW EXECUTE FUNCTION delivery.sfg_after_packing_list_entry_update_function();
 Q   DROP TRIGGER sfg_after_packing_list_entry_update ON delivery.packing_list_entry;
       delivery          postgres    false    431    236            �           2620    305485 .   info material_stock_after_material_info_delete    TRIGGER     �   CREATE TRIGGER material_stock_after_material_info_delete AFTER DELETE ON material.info FOR EACH ROW EXECUTE FUNCTION material.material_stock_after_material_info_delete();
 I   DROP TRIGGER material_stock_after_material_info_delete ON material.info;
       material          postgres    false    361    266            �           2620    305486 .   info material_stock_after_material_info_insert    TRIGGER     �   CREATE TRIGGER material_stock_after_material_info_insert AFTER INSERT ON material.info FOR EACH ROW EXECUTE FUNCTION material.material_stock_after_material_info_insert();
 I   DROP TRIGGER material_stock_after_material_info_insert ON material.info;
       material          postgres    false    266    329            �           2620    305487 ,   trx material_stock_after_material_trx_delete    TRIGGER     �   CREATE TRIGGER material_stock_after_material_trx_delete AFTER DELETE ON material.trx FOR EACH ROW EXECUTE FUNCTION material.material_stock_after_material_trx_delete();
 G   DROP TRIGGER material_stock_after_material_trx_delete ON material.trx;
       material          postgres    false    270    349            �           2620    305488 ,   trx material_stock_after_material_trx_insert    TRIGGER     �   CREATE TRIGGER material_stock_after_material_trx_insert AFTER INSERT ON material.trx FOR EACH ROW EXECUTE FUNCTION material.material_stock_after_material_trx_insert();
 G   DROP TRIGGER material_stock_after_material_trx_insert ON material.trx;
       material          postgres    false    394    270            �           2620    305489 ,   trx material_stock_after_material_trx_update    TRIGGER     �   CREATE TRIGGER material_stock_after_material_trx_update AFTER UPDATE ON material.trx FOR EACH ROW EXECUTE FUNCTION material.material_stock_after_material_trx_update();
 G   DROP TRIGGER material_stock_after_material_trx_update ON material.trx;
       material          postgres    false    270    384            �           2620    305490 .   used material_stock_after_material_used_delete    TRIGGER     �   CREATE TRIGGER material_stock_after_material_used_delete AFTER DELETE ON material.used FOR EACH ROW EXECUTE FUNCTION material.material_stock_after_material_used_delete();
 I   DROP TRIGGER material_stock_after_material_used_delete ON material.used;
       material          postgres    false    272    357            �           2620    305491 .   used material_stock_after_material_used_insert    TRIGGER     �   CREATE TRIGGER material_stock_after_material_used_insert AFTER INSERT ON material.used FOR EACH ROW EXECUTE FUNCTION material.material_stock_after_material_used_insert();
 I   DROP TRIGGER material_stock_after_material_used_insert ON material.used;
       material          postgres    false    272    420            �           2620    305492 .   used material_stock_after_material_used_update    TRIGGER     �   CREATE TRIGGER material_stock_after_material_used_update AFTER UPDATE ON material.used FOR EACH ROW EXECUTE FUNCTION material.material_stock_after_material_used_update();
 I   DROP TRIGGER material_stock_after_material_used_update ON material.used;
       material          postgres    false    272    430            �           2620    305493 9   stock_to_sfg material_stock_sfg_after_stock_to_sfg_delete    TRIGGER     �   CREATE TRIGGER material_stock_sfg_after_stock_to_sfg_delete AFTER DELETE ON material.stock_to_sfg FOR EACH ROW EXECUTE FUNCTION material.material_stock_sfg_after_stock_to_sfg_delete();
 T   DROP TRIGGER material_stock_sfg_after_stock_to_sfg_delete ON material.stock_to_sfg;
       material          postgres    false    269    428            �           2620    305494 9   stock_to_sfg material_stock_sfg_after_stock_to_sfg_insert    TRIGGER     �   CREATE TRIGGER material_stock_sfg_after_stock_to_sfg_insert AFTER INSERT ON material.stock_to_sfg FOR EACH ROW EXECUTE FUNCTION material.material_stock_sfg_after_stock_to_sfg_insert();
 T   DROP TRIGGER material_stock_sfg_after_stock_to_sfg_insert ON material.stock_to_sfg;
       material          postgres    false    382    269            �           2620    305495 9   stock_to_sfg material_stock_sfg_after_stock_to_sfg_update    TRIGGER     �   CREATE TRIGGER material_stock_sfg_after_stock_to_sfg_update AFTER UPDATE ON material.stock_to_sfg FOR EACH ROW EXECUTE FUNCTION material.material_stock_sfg_after_stock_to_sfg_update();
 T   DROP TRIGGER material_stock_sfg_after_stock_to_sfg_update ON material.stock_to_sfg;
       material          postgres    false    405    269            �           2620    305496 0   entry material_stock_after_purchase_entry_delete    TRIGGER     �   CREATE TRIGGER material_stock_after_purchase_entry_delete AFTER DELETE ON purchase.entry FOR EACH ROW EXECUTE FUNCTION material.material_stock_after_purchase_entry_delete();
 K   DROP TRIGGER material_stock_after_purchase_entry_delete ON purchase.entry;
       purchase          postgres    false    427    277            �           2620    305497 0   entry material_stock_after_purchase_entry_insert    TRIGGER     �   CREATE TRIGGER material_stock_after_purchase_entry_insert AFTER INSERT ON purchase.entry FOR EACH ROW EXECUTE FUNCTION material.material_stock_after_purchase_entry_insert();
 K   DROP TRIGGER material_stock_after_purchase_entry_insert ON purchase.entry;
       purchase          postgres    false    277    340            �           2620    305498 0   entry material_stock_after_purchase_entry_update    TRIGGER     �   CREATE TRIGGER material_stock_after_purchase_entry_update AFTER UPDATE ON purchase.entry FOR EACH ROW EXECUTE FUNCTION material.material_stock_after_purchase_entry_update();
 K   DROP TRIGGER material_stock_after_purchase_entry_update ON purchase.entry;
       purchase          postgres    false    387    277            �           2620    305499 W   die_casting_to_assembly_stock assembly_stock_after_die_casting_to_assembly_stock_delete    TRIGGER     �   CREATE TRIGGER assembly_stock_after_die_casting_to_assembly_stock_delete AFTER DELETE ON slider.die_casting_to_assembly_stock FOR EACH ROW EXECUTE FUNCTION slider.assembly_stock_after_die_casting_to_assembly_stock_delete_funct();
 p   DROP TRIGGER assembly_stock_after_die_casting_to_assembly_stock_delete ON slider.die_casting_to_assembly_stock;
       slider          postgres    false    407    283            �           2620    305500 W   die_casting_to_assembly_stock assembly_stock_after_die_casting_to_assembly_stock_insert    TRIGGER     �   CREATE TRIGGER assembly_stock_after_die_casting_to_assembly_stock_insert AFTER INSERT ON slider.die_casting_to_assembly_stock FOR EACH ROW EXECUTE FUNCTION slider.assembly_stock_after_die_casting_to_assembly_stock_insert_funct();
 p   DROP TRIGGER assembly_stock_after_die_casting_to_assembly_stock_insert ON slider.die_casting_to_assembly_stock;
       slider          postgres    false    379    283            �           2620    305501 W   die_casting_to_assembly_stock assembly_stock_after_die_casting_to_assembly_stock_update    TRIGGER     �   CREATE TRIGGER assembly_stock_after_die_casting_to_assembly_stock_update AFTER UPDATE ON slider.die_casting_to_assembly_stock FOR EACH ROW EXECUTE FUNCTION slider.assembly_stock_after_die_casting_to_assembly_stock_update_funct();
 p   DROP TRIGGER assembly_stock_after_die_casting_to_assembly_stock_update ON slider.die_casting_to_assembly_stock;
       slider          postgres    false    283    373            �           2620    305502 M   die_casting_production slider_die_casting_after_die_casting_production_delete    TRIGGER     �   CREATE TRIGGER slider_die_casting_after_die_casting_production_delete AFTER DELETE ON slider.die_casting_production FOR EACH ROW EXECUTE FUNCTION slider.slider_die_casting_after_die_casting_production_delete();
 f   DROP TRIGGER slider_die_casting_after_die_casting_production_delete ON slider.die_casting_production;
       slider          postgres    false    282    402            �           2620    305503 M   die_casting_production slider_die_casting_after_die_casting_production_insert    TRIGGER     �   CREATE TRIGGER slider_die_casting_after_die_casting_production_insert AFTER INSERT ON slider.die_casting_production FOR EACH ROW EXECUTE FUNCTION slider.slider_die_casting_after_die_casting_production_insert();
 f   DROP TRIGGER slider_die_casting_after_die_casting_production_insert ON slider.die_casting_production;
       slider          postgres    false    282    372            �           2620    305504 M   die_casting_production slider_die_casting_after_die_casting_production_update    TRIGGER     �   CREATE TRIGGER slider_die_casting_after_die_casting_production_update AFTER UPDATE ON slider.die_casting_production FOR EACH ROW EXECUTE FUNCTION slider.slider_die_casting_after_die_casting_production_update();
 f   DROP TRIGGER slider_die_casting_after_die_casting_production_update ON slider.die_casting_production;
       slider          postgres    false    364    282            �           2620    305505 C   trx_against_stock slider_die_casting_after_trx_against_stock_delete    TRIGGER     �   CREATE TRIGGER slider_die_casting_after_trx_against_stock_delete AFTER DELETE ON slider.trx_against_stock FOR EACH ROW EXECUTE FUNCTION slider.slider_die_casting_after_trx_against_stock_delete();
 \   DROP TRIGGER slider_die_casting_after_trx_against_stock_delete ON slider.trx_against_stock;
       slider          postgres    false    287    378            �           2620    305506 C   trx_against_stock slider_die_casting_after_trx_against_stock_insert    TRIGGER     �   CREATE TRIGGER slider_die_casting_after_trx_against_stock_insert AFTER INSERT ON slider.trx_against_stock FOR EACH ROW EXECUTE FUNCTION slider.slider_die_casting_after_trx_against_stock_insert();
 \   DROP TRIGGER slider_die_casting_after_trx_against_stock_insert ON slider.trx_against_stock;
       slider          postgres    false    380    287            �           2620    305507 C   trx_against_stock slider_die_casting_after_trx_against_stock_update    TRIGGER     �   CREATE TRIGGER slider_die_casting_after_trx_against_stock_update AFTER UPDATE ON slider.trx_against_stock FOR EACH ROW EXECUTE FUNCTION slider.slider_die_casting_after_trx_against_stock_update();
 \   DROP TRIGGER slider_die_casting_after_trx_against_stock_update ON slider.trx_against_stock;
       slider          postgres    false    323    287            �           2620    305508 C   coloring_transaction slider_stock_after_coloring_transaction_delete    TRIGGER     �   CREATE TRIGGER slider_stock_after_coloring_transaction_delete AFTER DELETE ON slider.coloring_transaction FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_coloring_transaction_delete();
 \   DROP TRIGGER slider_stock_after_coloring_transaction_delete ON slider.coloring_transaction;
       slider          postgres    false    433    280            �           2620    305509 C   coloring_transaction slider_stock_after_coloring_transaction_insert    TRIGGER     �   CREATE TRIGGER slider_stock_after_coloring_transaction_insert AFTER INSERT ON slider.coloring_transaction FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_coloring_transaction_insert();
 \   DROP TRIGGER slider_stock_after_coloring_transaction_insert ON slider.coloring_transaction;
       slider          postgres    false    280    362            �           2620    305510 C   coloring_transaction slider_stock_after_coloring_transaction_update    TRIGGER     �   CREATE TRIGGER slider_stock_after_coloring_transaction_update AFTER UPDATE ON slider.coloring_transaction FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_coloring_transaction_update();
 \   DROP TRIGGER slider_stock_after_coloring_transaction_update ON slider.coloring_transaction;
       slider          postgres    false    368    280            �           2620    305511 I   die_casting_transaction slider_stock_after_die_casting_transaction_delete    TRIGGER     �   CREATE TRIGGER slider_stock_after_die_casting_transaction_delete AFTER DELETE ON slider.die_casting_transaction FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_die_casting_transaction_delete();
 b   DROP TRIGGER slider_stock_after_die_casting_transaction_delete ON slider.die_casting_transaction;
       slider          postgres    false    284    358            �           2620    305512 I   die_casting_transaction slider_stock_after_die_casting_transaction_insert    TRIGGER     �   CREATE TRIGGER slider_stock_after_die_casting_transaction_insert AFTER INSERT ON slider.die_casting_transaction FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_die_casting_transaction_insert();
 b   DROP TRIGGER slider_stock_after_die_casting_transaction_insert ON slider.die_casting_transaction;
       slider          postgres    false    284    397            �           2620    305513 I   die_casting_transaction slider_stock_after_die_casting_transaction_update    TRIGGER     �   CREATE TRIGGER slider_stock_after_die_casting_transaction_update AFTER UPDATE ON slider.die_casting_transaction FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_die_casting_transaction_update();
 b   DROP TRIGGER slider_stock_after_die_casting_transaction_update ON slider.die_casting_transaction;
       slider          postgres    false    385    284            �           2620    305514 6   production slider_stock_after_slider_production_delete    TRIGGER     �   CREATE TRIGGER slider_stock_after_slider_production_delete AFTER DELETE ON slider.production FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_slider_production_delete();
 O   DROP TRIGGER slider_stock_after_slider_production_delete ON slider.production;
       slider          postgres    false    285    424            �           2620    305515 6   production slider_stock_after_slider_production_insert    TRIGGER     �   CREATE TRIGGER slider_stock_after_slider_production_insert AFTER INSERT ON slider.production FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_slider_production_insert();
 O   DROP TRIGGER slider_stock_after_slider_production_insert ON slider.production;
       slider          postgres    false    419    285            �           2620    305516 6   production slider_stock_after_slider_production_update    TRIGGER     �   CREATE TRIGGER slider_stock_after_slider_production_update AFTER UPDATE ON slider.production FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_slider_production_update();
 O   DROP TRIGGER slider_stock_after_slider_production_update ON slider.production;
       slider          postgres    false    374    285            �           2620    305517 1   transaction slider_stock_after_transaction_delete    TRIGGER     �   CREATE TRIGGER slider_stock_after_transaction_delete AFTER DELETE ON slider.transaction FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_transaction_delete();
 J   DROP TRIGGER slider_stock_after_transaction_delete ON slider.transaction;
       slider          postgres    false    286    413            �           2620    305518 1   transaction slider_stock_after_transaction_insert    TRIGGER     �   CREATE TRIGGER slider_stock_after_transaction_insert AFTER INSERT ON slider.transaction FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_transaction_insert();
 J   DROP TRIGGER slider_stock_after_transaction_insert ON slider.transaction;
       slider          postgres    false    286    337            �           2620    305519 1   transaction slider_stock_after_transaction_update    TRIGGER     �   CREATE TRIGGER slider_stock_after_transaction_update AFTER UPDATE ON slider.transaction FOR EACH ROW EXECUTE FUNCTION slider.slider_stock_after_transaction_update();
 J   DROP TRIGGER slider_stock_after_transaction_update ON slider.transaction;
       slider          postgres    false    342    286            �           2620    305520 7   batch order_entry_after_batch_is_dyeing_update_function    TRIGGER     �   CREATE TRIGGER order_entry_after_batch_is_dyeing_update_function AFTER UPDATE OF is_drying_complete ON thread.batch FOR EACH ROW EXECUTE FUNCTION thread.order_entry_after_batch_is_dyeing_update();
 P   DROP TRIGGER order_entry_after_batch_is_dyeing_update_function ON thread.batch;
       thread          postgres    false    426    289    289            �           2620    305521 M   batch_entry_production thread_batch_entry_after_batch_entry_production_delete    TRIGGER     �   CREATE TRIGGER thread_batch_entry_after_batch_entry_production_delete AFTER DELETE ON thread.batch_entry_production FOR EACH ROW EXECUTE FUNCTION public.thread_batch_entry_after_batch_entry_production_delete_funct();
 f   DROP TRIGGER thread_batch_entry_after_batch_entry_production_delete ON thread.batch_entry_production;
       thread          postgres    false    291    365            �           2620    305522 M   batch_entry_production thread_batch_entry_after_batch_entry_production_insert    TRIGGER     �   CREATE TRIGGER thread_batch_entry_after_batch_entry_production_insert AFTER INSERT ON thread.batch_entry_production FOR EACH ROW EXECUTE FUNCTION public.thread_batch_entry_after_batch_entry_production_insert_funct();
 f   DROP TRIGGER thread_batch_entry_after_batch_entry_production_insert ON thread.batch_entry_production;
       thread          postgres    false    355    291            �           2620    305523 M   batch_entry_production thread_batch_entry_after_batch_entry_production_update    TRIGGER     �   CREATE TRIGGER thread_batch_entry_after_batch_entry_production_update AFTER UPDATE ON thread.batch_entry_production FOR EACH ROW EXECUTE FUNCTION public.thread_batch_entry_after_batch_entry_production_update_funct();
 f   DROP TRIGGER thread_batch_entry_after_batch_entry_production_update ON thread.batch_entry_production;
       thread          postgres    false    291    392            �           2620    305524 H   batch_entry_trx thread_batch_entry_and_order_entry_after_batch_entry_trx    TRIGGER     �   CREATE TRIGGER thread_batch_entry_and_order_entry_after_batch_entry_trx AFTER INSERT ON thread.batch_entry_trx FOR EACH ROW EXECUTE FUNCTION public.thread_batch_entry_and_order_entry_after_batch_entry_trx_funct();
 a   DROP TRIGGER thread_batch_entry_and_order_entry_after_batch_entry_trx ON thread.batch_entry_trx;
       thread          postgres    false    292    415            �           2620    305525 O   batch_entry_trx thread_batch_entry_and_order_entry_after_batch_entry_trx_delete    TRIGGER     �   CREATE TRIGGER thread_batch_entry_and_order_entry_after_batch_entry_trx_delete AFTER DELETE ON thread.batch_entry_trx FOR EACH ROW EXECUTE FUNCTION public.thread_batch_entry_and_order_entry_after_batch_entry_trx_delete();
 h   DROP TRIGGER thread_batch_entry_and_order_entry_after_batch_entry_trx_delete ON thread.batch_entry_trx;
       thread          postgres    false    345    292            �           2620    305526 O   batch_entry_trx thread_batch_entry_and_order_entry_after_batch_entry_trx_update    TRIGGER     �   CREATE TRIGGER thread_batch_entry_and_order_entry_after_batch_entry_trx_update AFTER UPDATE ON thread.batch_entry_trx FOR EACH ROW EXECUTE FUNCTION public.thread_batch_entry_and_order_entry_after_batch_entry_trx_update();
 h   DROP TRIGGER thread_batch_entry_and_order_entry_after_batch_entry_trx_update ON thread.batch_entry_trx;
       thread          postgres    false    369    292            �           2620    305527 1   challan thread_order_entry_after_challan_received    TRIGGER     �   CREATE TRIGGER thread_order_entry_after_challan_received AFTER UPDATE OF received ON thread.challan FOR EACH ROW EXECUTE FUNCTION public.thread_order_entry_after_challan_received();
 J   DROP TRIGGER thread_order_entry_after_challan_received ON thread.challan;
       thread          postgres    false    294    344    294            �           2620    305528 F   order_description multi_color_dashboard_after_order_description_delete    TRIGGER     �   CREATE TRIGGER multi_color_dashboard_after_order_description_delete AFTER DELETE ON zipper.order_description FOR EACH ROW EXECUTE FUNCTION zipper.multi_color_dashboard_after_order_description_delete();
 _   DROP TRIGGER multi_color_dashboard_after_order_description_delete ON zipper.order_description;
       zipper          postgres    false    339    245            �           2620    305529 F   order_description multi_color_dashboard_after_order_description_insert    TRIGGER     �   CREATE TRIGGER multi_color_dashboard_after_order_description_insert AFTER INSERT ON zipper.order_description FOR EACH ROW EXECUTE FUNCTION zipper.multi_color_dashboard_after_order_description_insert();
 _   DROP TRIGGER multi_color_dashboard_after_order_description_insert ON zipper.order_description;
       zipper          postgres    false    395    245            �           2620    305530 F   order_description multi_color_dashboard_after_order_description_update    TRIGGER     �   CREATE TRIGGER multi_color_dashboard_after_order_description_update AFTER UPDATE ON zipper.order_description FOR EACH ROW EXECUTE FUNCTION zipper.multi_color_dashboard_after_order_description_update();
 _   DROP TRIGGER multi_color_dashboard_after_order_description_update ON zipper.order_description;
       zipper          postgres    false    245    425            �           2620    305531 R   dyed_tape_transaction order_description_after_dyed_tape_transaction_delete_trigger    TRIGGER     �   CREATE TRIGGER order_description_after_dyed_tape_transaction_delete_trigger AFTER DELETE ON zipper.dyed_tape_transaction FOR EACH ROW EXECUTE FUNCTION zipper.order_description_after_dyed_tape_transaction_delete();
 k   DROP TRIGGER order_description_after_dyed_tape_transaction_delete_trigger ON zipper.dyed_tape_transaction;
       zipper          postgres    false    306    360            �           2620    305532 R   dyed_tape_transaction order_description_after_dyed_tape_transaction_insert_trigger    TRIGGER     �   CREATE TRIGGER order_description_after_dyed_tape_transaction_insert_trigger AFTER INSERT ON zipper.dyed_tape_transaction FOR EACH ROW EXECUTE FUNCTION zipper.order_description_after_dyed_tape_transaction_insert();
 k   DROP TRIGGER order_description_after_dyed_tape_transaction_insert_trigger ON zipper.dyed_tape_transaction;
       zipper          postgres    false    348    306            �           2620    305533 R   dyed_tape_transaction order_description_after_dyed_tape_transaction_update_trigger    TRIGGER     �   CREATE TRIGGER order_description_after_dyed_tape_transaction_update_trigger AFTER UPDATE ON zipper.dyed_tape_transaction FOR EACH ROW EXECUTE FUNCTION zipper.order_description_after_dyed_tape_transaction_update();
 k   DROP TRIGGER order_description_after_dyed_tape_transaction_update_trigger ON zipper.dyed_tape_transaction;
       zipper          postgres    false    306    330            �           2620    305534 X   multi_color_tape_receive order_description_after_multi_color_tape_receive_delete_trigger    TRIGGER     �   CREATE TRIGGER order_description_after_multi_color_tape_receive_delete_trigger AFTER DELETE ON zipper.multi_color_tape_receive FOR EACH ROW EXECUTE FUNCTION zipper.order_description_after_multi_color_tape_receive_delete();
 q   DROP TRIGGER order_description_after_multi_color_tape_receive_delete_trigger ON zipper.multi_color_tape_receive;
       zipper          postgres    false    313    328            �           2620    305535 X   multi_color_tape_receive order_description_after_multi_color_tape_receive_insert_trigger    TRIGGER     �   CREATE TRIGGER order_description_after_multi_color_tape_receive_insert_trigger AFTER INSERT ON zipper.multi_color_tape_receive FOR EACH ROW EXECUTE FUNCTION zipper.order_description_after_multi_color_tape_receive_insert();
 q   DROP TRIGGER order_description_after_multi_color_tape_receive_insert_trigger ON zipper.multi_color_tape_receive;
       zipper          postgres    false    313    333            �           2620    305536 X   multi_color_tape_receive order_description_after_multi_color_tape_receive_update_trigger    TRIGGER     �   CREATE TRIGGER order_description_after_multi_color_tape_receive_update_trigger AFTER UPDATE ON zipper.multi_color_tape_receive FOR EACH ROW EXECUTE FUNCTION zipper.order_description_after_multi_color_tape_receive_update();
 q   DROP TRIGGER order_description_after_multi_color_tape_receive_update_trigger ON zipper.multi_color_tape_receive;
       zipper          postgres    false    313    411            �           2620    305537 (   order_entry sfg_after_order_entry_delete    TRIGGER     �   CREATE TRIGGER sfg_after_order_entry_delete AFTER DELETE ON zipper.order_entry FOR EACH ROW EXECUTE FUNCTION zipper.sfg_after_order_entry_delete();
 A   DROP TRIGGER sfg_after_order_entry_delete ON zipper.order_entry;
       zipper          postgres    false    246    383            �           2620    305538 (   order_entry sfg_after_order_entry_insert    TRIGGER     �   CREATE TRIGGER sfg_after_order_entry_insert AFTER INSERT ON zipper.order_entry FOR EACH ROW EXECUTE FUNCTION zipper.sfg_after_order_entry_insert();
 A   DROP TRIGGER sfg_after_order_entry_insert ON zipper.order_entry;
       zipper          postgres    false    246    423            �           2620    305539 6   sfg_production sfg_after_sfg_production_delete_trigger    TRIGGER     �   CREATE TRIGGER sfg_after_sfg_production_delete_trigger AFTER DELETE ON zipper.sfg_production FOR EACH ROW EXECUTE FUNCTION zipper.sfg_after_sfg_production_delete_function();
 O   DROP TRIGGER sfg_after_sfg_production_delete_trigger ON zipper.sfg_production;
       zipper          postgres    false    417    316            �           2620    305540 6   sfg_production sfg_after_sfg_production_insert_trigger    TRIGGER     �   CREATE TRIGGER sfg_after_sfg_production_insert_trigger AFTER INSERT ON zipper.sfg_production FOR EACH ROW EXECUTE FUNCTION zipper.sfg_after_sfg_production_insert_function();
 O   DROP TRIGGER sfg_after_sfg_production_insert_trigger ON zipper.sfg_production;
       zipper          postgres    false    404    316            �           2620    305541 6   sfg_production sfg_after_sfg_production_update_trigger    TRIGGER     �   CREATE TRIGGER sfg_after_sfg_production_update_trigger AFTER UPDATE ON zipper.sfg_production FOR EACH ROW EXECUTE FUNCTION zipper.sfg_after_sfg_production_update_function();
 O   DROP TRIGGER sfg_after_sfg_production_update_trigger ON zipper.sfg_production;
       zipper          postgres    false    346    316            �           2620    305542 8   sfg_transaction sfg_after_sfg_transaction_delete_trigger    TRIGGER     �   CREATE TRIGGER sfg_after_sfg_transaction_delete_trigger AFTER DELETE ON zipper.sfg_transaction FOR EACH ROW EXECUTE FUNCTION zipper.sfg_after_sfg_transaction_delete_function();
 Q   DROP TRIGGER sfg_after_sfg_transaction_delete_trigger ON zipper.sfg_transaction;
       zipper          postgres    false    371    317            �           2620    305543 8   sfg_transaction sfg_after_sfg_transaction_insert_trigger    TRIGGER     �   CREATE TRIGGER sfg_after_sfg_transaction_insert_trigger AFTER INSERT ON zipper.sfg_transaction FOR EACH ROW EXECUTE FUNCTION zipper.sfg_after_sfg_transaction_insert_function();
 Q   DROP TRIGGER sfg_after_sfg_transaction_insert_trigger ON zipper.sfg_transaction;
       zipper          postgres    false    317    409            �           2620    305544 8   sfg_transaction sfg_after_sfg_transaction_update_trigger    TRIGGER     �   CREATE TRIGGER sfg_after_sfg_transaction_update_trigger AFTER UPDATE ON zipper.sfg_transaction FOR EACH ROW EXECUTE FUNCTION zipper.sfg_after_sfg_transaction_update_function();
 Q   DROP TRIGGER sfg_after_sfg_transaction_update_trigger ON zipper.sfg_transaction;
       zipper          postgres    false    356    317            �           2620    305545 `   material_trx_against_order_description stock_after_material_trx_against_order_description_delete    TRIGGER     �   CREATE TRIGGER stock_after_material_trx_against_order_description_delete AFTER DELETE ON zipper.material_trx_against_order_description FOR EACH ROW EXECUTE FUNCTION zipper.stock_after_material_trx_against_order_description_delete_funct();
 y   DROP TRIGGER stock_after_material_trx_against_order_description_delete ON zipper.material_trx_against_order_description;
       zipper          postgres    false    359    311            �           2620    305546 `   material_trx_against_order_description stock_after_material_trx_against_order_description_insert    TRIGGER     �   CREATE TRIGGER stock_after_material_trx_against_order_description_insert AFTER INSERT ON zipper.material_trx_against_order_description FOR EACH ROW EXECUTE FUNCTION zipper.stock_after_material_trx_against_order_description_insert_funct();
 y   DROP TRIGGER stock_after_material_trx_against_order_description_insert ON zipper.material_trx_against_order_description;
       zipper          postgres    false    341    311            �           2620    305547 `   material_trx_against_order_description stock_after_material_trx_against_order_description_update    TRIGGER     �   CREATE TRIGGER stock_after_material_trx_against_order_description_update AFTER UPDATE ON zipper.material_trx_against_order_description FOR EACH ROW EXECUTE FUNCTION zipper.stock_after_material_trx_against_order_description_update_funct();
 y   DROP TRIGGER stock_after_material_trx_against_order_description_update ON zipper.material_trx_against_order_description;
       zipper          postgres    false    422    311            �           2620    305548 9   tape_coil_production tape_coil_after_tape_coil_production    TRIGGER     �   CREATE TRIGGER tape_coil_after_tape_coil_production AFTER INSERT ON zipper.tape_coil_production FOR EACH ROW EXECUTE FUNCTION zipper.tape_coil_after_tape_coil_production();
 R   DROP TRIGGER tape_coil_after_tape_coil_production ON zipper.tape_coil_production;
       zipper          postgres    false    318    412            �           2620    305549 @   tape_coil_production tape_coil_after_tape_coil_production_delete    TRIGGER     �   CREATE TRIGGER tape_coil_after_tape_coil_production_delete AFTER DELETE ON zipper.tape_coil_production FOR EACH ROW EXECUTE FUNCTION zipper.tape_coil_after_tape_coil_production_delete();
 Y   DROP TRIGGER tape_coil_after_tape_coil_production_delete ON zipper.tape_coil_production;
       zipper          postgres    false    318    400            �           2620    305550 @   tape_coil_production tape_coil_after_tape_coil_production_update    TRIGGER     �   CREATE TRIGGER tape_coil_after_tape_coil_production_update AFTER UPDATE ON zipper.tape_coil_production FOR EACH ROW EXECUTE FUNCTION zipper.tape_coil_after_tape_coil_production_update();
 Y   DROP TRIGGER tape_coil_after_tape_coil_production_update ON zipper.tape_coil_production;
       zipper          postgres    false    370    318            �           2620    305551 .   tape_trx tape_coil_after_tape_trx_after_delete    TRIGGER     �   CREATE TRIGGER tape_coil_after_tape_trx_after_delete AFTER DELETE ON zipper.tape_trx FOR EACH ROW EXECUTE FUNCTION zipper.tape_coil_after_tape_trx_delete();
 G   DROP TRIGGER tape_coil_after_tape_trx_after_delete ON zipper.tape_trx;
       zipper          postgres    false    321    386            �           2620    305552 .   tape_trx tape_coil_after_tape_trx_after_insert    TRIGGER     �   CREATE TRIGGER tape_coil_after_tape_trx_after_insert AFTER INSERT ON zipper.tape_trx FOR EACH ROW EXECUTE FUNCTION zipper.tape_coil_after_tape_trx_insert();
 G   DROP TRIGGER tape_coil_after_tape_trx_after_insert ON zipper.tape_trx;
       zipper          postgres    false    321    327            �           2620    305553 .   tape_trx tape_coil_after_tape_trx_after_update    TRIGGER     �   CREATE TRIGGER tape_coil_after_tape_trx_after_update AFTER UPDATE ON zipper.tape_trx FOR EACH ROW EXECUTE FUNCTION zipper.tape_coil_after_tape_trx_update();
 G   DROP TRIGGER tape_coil_after_tape_trx_after_update ON zipper.tape_trx;
       zipper          postgres    false    321    354            �           2620    305554 `   dyed_tape_transaction_from_stock tape_coil_and_order_description_after_dyed_tape_transaction_del    TRIGGER     �   CREATE TRIGGER tape_coil_and_order_description_after_dyed_tape_transaction_del AFTER DELETE ON zipper.dyed_tape_transaction_from_stock FOR EACH ROW EXECUTE FUNCTION zipper.tape_coil_and_order_description_after_dyed_tape_transaction_del();
 y   DROP TRIGGER tape_coil_and_order_description_after_dyed_tape_transaction_del ON zipper.dyed_tape_transaction_from_stock;
       zipper          postgres    false    307    396            �           2620    305555 `   dyed_tape_transaction_from_stock tape_coil_and_order_description_after_dyed_tape_transaction_ins    TRIGGER     �   CREATE TRIGGER tape_coil_and_order_description_after_dyed_tape_transaction_ins AFTER INSERT ON zipper.dyed_tape_transaction_from_stock FOR EACH ROW EXECUTE FUNCTION zipper.tape_coil_and_order_description_after_dyed_tape_transaction_ins();
 y   DROP TRIGGER tape_coil_and_order_description_after_dyed_tape_transaction_ins ON zipper.dyed_tape_transaction_from_stock;
       zipper          postgres    false    350    307            �           2620    305556 `   dyed_tape_transaction_from_stock tape_coil_and_order_description_after_dyed_tape_transaction_upd    TRIGGER     �   CREATE TRIGGER tape_coil_and_order_description_after_dyed_tape_transaction_upd AFTER UPDATE ON zipper.dyed_tape_transaction_from_stock FOR EACH ROW EXECUTE FUNCTION zipper.tape_coil_and_order_description_after_dyed_tape_transaction_upd();
 y   DROP TRIGGER tape_coil_and_order_description_after_dyed_tape_transaction_upd ON zipper.dyed_tape_transaction_from_stock;
       zipper          postgres    false    307    363            �           2620    305557 4   tape_coil_to_dyeing tape_coil_to_dyeing_after_delete    TRIGGER     �   CREATE TRIGGER tape_coil_to_dyeing_after_delete AFTER DELETE ON zipper.tape_coil_to_dyeing FOR EACH ROW EXECUTE FUNCTION zipper.order_description_after_tape_coil_to_dyeing_delete();
 M   DROP TRIGGER tape_coil_to_dyeing_after_delete ON zipper.tape_coil_to_dyeing;
       zipper          postgres    false    320    410            �           2620    305558 4   tape_coil_to_dyeing tape_coil_to_dyeing_after_insert    TRIGGER     �   CREATE TRIGGER tape_coil_to_dyeing_after_insert AFTER INSERT ON zipper.tape_coil_to_dyeing FOR EACH ROW EXECUTE FUNCTION zipper.order_description_after_tape_coil_to_dyeing_insert();
 M   DROP TRIGGER tape_coil_to_dyeing_after_insert ON zipper.tape_coil_to_dyeing;
       zipper          postgres    false    421    320            �           2620    305559 4   tape_coil_to_dyeing tape_coil_to_dyeing_after_update    TRIGGER     �   CREATE TRIGGER tape_coil_to_dyeing_after_update AFTER UPDATE ON zipper.tape_coil_to_dyeing FOR EACH ROW EXECUTE FUNCTION zipper.order_description_after_tape_coil_to_dyeing_update();
 M   DROP TRIGGER tape_coil_to_dyeing_after_update ON zipper.tape_coil_to_dyeing;
       zipper          postgres    false    353    320            �           2620    305560 A   batch_production zipper_batch_entry_after_batch_production_delete    TRIGGER     �   CREATE TRIGGER zipper_batch_entry_after_batch_production_delete AFTER DELETE ON zipper.batch_production FOR EACH ROW EXECUTE FUNCTION public.zipper_batch_entry_after_batch_production_delete();
 Z   DROP TRIGGER zipper_batch_entry_after_batch_production_delete ON zipper.batch_production;
       zipper          postgres    false    389    305            �           2620    305561 A   batch_production zipper_batch_entry_after_batch_production_insert    TRIGGER     �   CREATE TRIGGER zipper_batch_entry_after_batch_production_insert AFTER INSERT ON zipper.batch_production FOR EACH ROW EXECUTE FUNCTION public.zipper_batch_entry_after_batch_production_insert();
 Z   DROP TRIGGER zipper_batch_entry_after_batch_production_insert ON zipper.batch_production;
       zipper          postgres    false    305    351            �           2620    305562 A   batch_production zipper_batch_entry_after_batch_production_update    TRIGGER     �   CREATE TRIGGER zipper_batch_entry_after_batch_production_update AFTER UPDATE ON zipper.batch_production FOR EACH ROW EXECUTE FUNCTION public.zipper_batch_entry_after_batch_production_update();
 Z   DROP TRIGGER zipper_batch_entry_after_batch_production_update ON zipper.batch_production;
       zipper          postgres    false    399    305            �           2620    305563 ,   batch zipper_sfg_after_batch_received_update    TRIGGER     �   CREATE TRIGGER zipper_sfg_after_batch_received_update AFTER UPDATE OF received ON zipper.batch FOR EACH ROW EXECUTE FUNCTION public.zipper_sfg_after_batch_received_update();
 E   DROP TRIGGER zipper_sfg_after_batch_received_update ON zipper.batch;
       zipper          postgres    false    302    432    302            �           2606    305564 "   bank bank_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.bank
    ADD CONSTRAINT bank_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 P   ALTER TABLE ONLY commercial.bank DROP CONSTRAINT bank_created_by_users_uuid_fk;
    
   commercial          postgres    false    237    5385    225            �           2606    305569    lc lc_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.lc
    ADD CONSTRAINT lc_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 L   ALTER TABLE ONLY commercial.lc DROP CONSTRAINT lc_created_by_users_uuid_fk;
    
   commercial          postgres    false    237    5385    227            �           2606    305574    lc lc_party_uuid_party_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.lc
    ADD CONSTRAINT lc_party_uuid_party_uuid_fk FOREIGN KEY (party_uuid) REFERENCES public.party(uuid);
 L   ALTER TABLE ONLY commercial.lc DROP CONSTRAINT lc_party_uuid_party_uuid_fk;
    
   commercial          postgres    false    5405    227    242            �           2606    305579 &   pi_cash pi_cash_bank_uuid_bank_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.pi_cash
    ADD CONSTRAINT pi_cash_bank_uuid_bank_uuid_fk FOREIGN KEY (bank_uuid) REFERENCES commercial.bank(uuid);
 T   ALTER TABLE ONLY commercial.pi_cash DROP CONSTRAINT pi_cash_bank_uuid_bank_uuid_fk;
    
   commercial          postgres    false    225    5367    229            �           2606    305584 (   pi_cash pi_cash_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.pi_cash
    ADD CONSTRAINT pi_cash_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 V   ALTER TABLE ONLY commercial.pi_cash DROP CONSTRAINT pi_cash_created_by_users_uuid_fk;
    
   commercial          postgres    false    237    229    5385            �           2606    305589 8   pi_cash_entry pi_cash_entry_pi_cash_uuid_pi_cash_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.pi_cash_entry
    ADD CONSTRAINT pi_cash_entry_pi_cash_uuid_pi_cash_uuid_fk FOREIGN KEY (pi_cash_uuid) REFERENCES commercial.pi_cash(uuid);
 f   ALTER TABLE ONLY commercial.pi_cash_entry DROP CONSTRAINT pi_cash_entry_pi_cash_uuid_pi_cash_uuid_fk;
    
   commercial          postgres    false    230    229    5371            �           2606    305594 0   pi_cash_entry pi_cash_entry_sfg_uuid_sfg_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.pi_cash_entry
    ADD CONSTRAINT pi_cash_entry_sfg_uuid_sfg_uuid_fk FOREIGN KEY (sfg_uuid) REFERENCES zipper.sfg(uuid);
 ^   ALTER TABLE ONLY commercial.pi_cash_entry DROP CONSTRAINT pi_cash_entry_sfg_uuid_sfg_uuid_fk;
    
   commercial          postgres    false    5417    230    249            �           2606    305599 G   pi_cash_entry pi_cash_entry_thread_order_entry_uuid_order_entry_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.pi_cash_entry
    ADD CONSTRAINT pi_cash_entry_thread_order_entry_uuid_order_entry_uuid_fk FOREIGN KEY (thread_order_entry_uuid) REFERENCES thread.order_entry(uuid);
 u   ALTER TABLE ONLY commercial.pi_cash_entry DROP CONSTRAINT pi_cash_entry_thread_order_entry_uuid_order_entry_uuid_fk;
    
   commercial          postgres    false    298    230    5505            �           2606    305604 ,   pi_cash pi_cash_factory_uuid_factory_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.pi_cash
    ADD CONSTRAINT pi_cash_factory_uuid_factory_uuid_fk FOREIGN KEY (factory_uuid) REFERENCES public.factory(uuid);
 Z   ALTER TABLE ONLY commercial.pi_cash DROP CONSTRAINT pi_cash_factory_uuid_factory_uuid_fk;
    
   commercial          postgres    false    5393    239    229            �           2606    305609 "   pi_cash pi_cash_lc_uuid_lc_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.pi_cash
    ADD CONSTRAINT pi_cash_lc_uuid_lc_uuid_fk FOREIGN KEY (lc_uuid) REFERENCES commercial.lc(uuid);
 P   ALTER TABLE ONLY commercial.pi_cash DROP CONSTRAINT pi_cash_lc_uuid_lc_uuid_fk;
    
   commercial          postgres    false    229    5369    227            �           2606    305614 0   pi_cash pi_cash_marketing_uuid_marketing_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.pi_cash
    ADD CONSTRAINT pi_cash_marketing_uuid_marketing_uuid_fk FOREIGN KEY (marketing_uuid) REFERENCES public.marketing(uuid);
 ^   ALTER TABLE ONLY commercial.pi_cash DROP CONSTRAINT pi_cash_marketing_uuid_marketing_uuid_fk;
    
   commercial          postgres    false    229    240    5397            �           2606    305619 6   pi_cash pi_cash_merchandiser_uuid_merchandiser_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.pi_cash
    ADD CONSTRAINT pi_cash_merchandiser_uuid_merchandiser_uuid_fk FOREIGN KEY (merchandiser_uuid) REFERENCES public.merchandiser(uuid);
 d   ALTER TABLE ONLY commercial.pi_cash DROP CONSTRAINT pi_cash_merchandiser_uuid_merchandiser_uuid_fk;
    
   commercial          postgres    false    5401    241    229            �           2606    305624 (   pi_cash pi_cash_party_uuid_party_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY commercial.pi_cash
    ADD CONSTRAINT pi_cash_party_uuid_party_uuid_fk FOREIGN KEY (party_uuid) REFERENCES public.party(uuid);
 V   ALTER TABLE ONLY commercial.pi_cash DROP CONSTRAINT pi_cash_party_uuid_party_uuid_fk;
    
   commercial          postgres    false    229    242    5405            �           2606    305629 '   challan challan_assign_to_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY delivery.challan
    ADD CONSTRAINT challan_assign_to_users_uuid_fk FOREIGN KEY (assign_to) REFERENCES hr.users(uuid);
 S   ALTER TABLE ONLY delivery.challan DROP CONSTRAINT challan_assign_to_users_uuid_fk;
       delivery          postgres    false    237    5385    232            �           2606    305634 (   challan challan_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY delivery.challan
    ADD CONSTRAINT challan_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 T   ALTER TABLE ONLY delivery.challan DROP CONSTRAINT challan_created_by_users_uuid_fk;
       delivery          postgres    false    237    5385    232            �           2606    305639 8   challan_entry challan_entry_challan_uuid_challan_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY delivery.challan_entry
    ADD CONSTRAINT challan_entry_challan_uuid_challan_uuid_fk FOREIGN KEY (challan_uuid) REFERENCES delivery.challan(uuid);
 d   ALTER TABLE ONLY delivery.challan_entry DROP CONSTRAINT challan_entry_challan_uuid_challan_uuid_fk;
       delivery          postgres    false    233    5375    232            �           2606    305644 B   challan_entry challan_entry_packing_list_uuid_packing_list_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY delivery.challan_entry
    ADD CONSTRAINT challan_entry_packing_list_uuid_packing_list_uuid_fk FOREIGN KEY (packing_list_uuid) REFERENCES delivery.packing_list(uuid);
 n   ALTER TABLE ONLY delivery.challan_entry DROP CONSTRAINT challan_entry_packing_list_uuid_packing_list_uuid_fk;
       delivery          postgres    false    235    5379    233            �           2606    305649 2   challan challan_order_info_uuid_order_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY delivery.challan
    ADD CONSTRAINT challan_order_info_uuid_order_info_uuid_fk FOREIGN KEY (order_info_uuid) REFERENCES zipper.order_info(uuid);
 ^   ALTER TABLE ONLY delivery.challan DROP CONSTRAINT challan_order_info_uuid_order_info_uuid_fk;
       delivery          postgres    false    232    248    5415            �           2606    305654 6   packing_list packing_list_challan_uuid_challan_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY delivery.packing_list
    ADD CONSTRAINT packing_list_challan_uuid_challan_uuid_fk FOREIGN KEY (challan_uuid) REFERENCES delivery.challan(uuid);
 b   ALTER TABLE ONLY delivery.packing_list DROP CONSTRAINT packing_list_challan_uuid_challan_uuid_fk;
       delivery          postgres    false    232    235    5375            �           2606    305659 2   packing_list packing_list_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY delivery.packing_list
    ADD CONSTRAINT packing_list_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 ^   ALTER TABLE ONLY delivery.packing_list DROP CONSTRAINT packing_list_created_by_users_uuid_fk;
       delivery          postgres    false    235    237    5385            �           2606    305664 L   packing_list_entry packing_list_entry_packing_list_uuid_packing_list_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY delivery.packing_list_entry
    ADD CONSTRAINT packing_list_entry_packing_list_uuid_packing_list_uuid_fk FOREIGN KEY (packing_list_uuid) REFERENCES delivery.packing_list(uuid);
 x   ALTER TABLE ONLY delivery.packing_list_entry DROP CONSTRAINT packing_list_entry_packing_list_uuid_packing_list_uuid_fk;
       delivery          postgres    false    236    235    5379            �           2606    305669 :   packing_list_entry packing_list_entry_sfg_uuid_sfg_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY delivery.packing_list_entry
    ADD CONSTRAINT packing_list_entry_sfg_uuid_sfg_uuid_fk FOREIGN KEY (sfg_uuid) REFERENCES zipper.sfg(uuid);
 f   ALTER TABLE ONLY delivery.packing_list_entry DROP CONSTRAINT packing_list_entry_sfg_uuid_sfg_uuid_fk;
       delivery          postgres    false    249    5417    236            �           2606    305674 <   packing_list packing_list_order_info_uuid_order_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY delivery.packing_list
    ADD CONSTRAINT packing_list_order_info_uuid_order_info_uuid_fk FOREIGN KEY (order_info_uuid) REFERENCES zipper.order_info(uuid);
 h   ALTER TABLE ONLY delivery.packing_list DROP CONSTRAINT packing_list_order_info_uuid_order_info_uuid_fk;
       delivery          postgres    false    235    5415    248            �           2606    305679    users hr_user_department    FK CONSTRAINT     ~   ALTER TABLE ONLY hr.users
    ADD CONSTRAINT hr_user_department FOREIGN KEY (department_uuid) REFERENCES hr.department(uuid);
 >   ALTER TABLE ONLY hr.users DROP CONSTRAINT hr_user_department;
       hr          postgres    false    237    5425    255            �           2606    305684 <   policy_and_notice policy_and_notice_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY hr.policy_and_notice
    ADD CONSTRAINT policy_and_notice_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 b   ALTER TABLE ONLY hr.policy_and_notice DROP CONSTRAINT policy_and_notice_created_by_users_uuid_fk;
       hr          postgres    false    237    257    5385            �           2606    305689 .   users users_department_uuid_department_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY hr.users
    ADD CONSTRAINT users_department_uuid_department_uuid_fk FOREIGN KEY (department_uuid) REFERENCES hr.department(uuid);
 T   ALTER TABLE ONLY hr.users DROP CONSTRAINT users_department_uuid_department_uuid_fk;
       hr          postgres    false    237    5425    255            �           2606    305694 0   users users_designation_uuid_designation_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY hr.users
    ADD CONSTRAINT users_designation_uuid_designation_uuid_fk FOREIGN KEY (designation_uuid) REFERENCES hr.designation(uuid);
 V   ALTER TABLE ONLY hr.users DROP CONSTRAINT users_designation_uuid_designation_uuid_fk;
       hr          postgres    false    237    256    5431            �           2606    305699 "   info info_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY lab_dip.info
    ADD CONSTRAINT info_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 M   ALTER TABLE ONLY lab_dip.info DROP CONSTRAINT info_created_by_users_uuid_fk;
       lab_dip          postgres    false    258    237    5385            �           2606    305704 ,   info info_order_info_uuid_order_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY lab_dip.info
    ADD CONSTRAINT info_order_info_uuid_order_info_uuid_fk FOREIGN KEY (order_info_uuid) REFERENCES zipper.order_info(uuid);
 W   ALTER TABLE ONLY lab_dip.info DROP CONSTRAINT info_order_info_uuid_order_info_uuid_fk;
       lab_dip          postgres    false    5415    248    258            �           2606    305709 3   info info_thread_order_info_uuid_order_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY lab_dip.info
    ADD CONSTRAINT info_thread_order_info_uuid_order_info_uuid_fk FOREIGN KEY (thread_order_info_uuid) REFERENCES thread.order_info(uuid);
 ^   ALTER TABLE ONLY lab_dip.info DROP CONSTRAINT info_thread_order_info_uuid_order_info_uuid_fk;
       lab_dip          postgres    false    258    5507    300            �           2606    305714 &   recipe recipe_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY lab_dip.recipe
    ADD CONSTRAINT recipe_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 Q   ALTER TABLE ONLY lab_dip.recipe DROP CONSTRAINT recipe_created_by_users_uuid_fk;
       lab_dip          postgres    false    237    260    5385            �           2606    305719 4   recipe_entry recipe_entry_material_uuid_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY lab_dip.recipe_entry
    ADD CONSTRAINT recipe_entry_material_uuid_info_uuid_fk FOREIGN KEY (material_uuid) REFERENCES material.info(uuid);
 _   ALTER TABLE ONLY lab_dip.recipe_entry DROP CONSTRAINT recipe_entry_material_uuid_info_uuid_fk;
       lab_dip          postgres    false    266    261    5447            �           2606    305724 4   recipe_entry recipe_entry_recipe_uuid_recipe_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY lab_dip.recipe_entry
    ADD CONSTRAINT recipe_entry_recipe_uuid_recipe_uuid_fk FOREIGN KEY (recipe_uuid) REFERENCES lab_dip.recipe(uuid);
 _   ALTER TABLE ONLY lab_dip.recipe_entry DROP CONSTRAINT recipe_entry_recipe_uuid_recipe_uuid_fk;
       lab_dip          postgres    false    260    261    5439            �           2606    305729 ,   recipe recipe_lab_dip_info_uuid_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY lab_dip.recipe
    ADD CONSTRAINT recipe_lab_dip_info_uuid_info_uuid_fk FOREIGN KEY (lab_dip_info_uuid) REFERENCES lab_dip.info(uuid);
 W   ALTER TABLE ONLY lab_dip.recipe DROP CONSTRAINT recipe_lab_dip_info_uuid_info_uuid_fk;
       lab_dip          postgres    false    258    260    5437            �           2606    305734 2   shade_recipe shade_recipe_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY lab_dip.shade_recipe
    ADD CONSTRAINT shade_recipe_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 ]   ALTER TABLE ONLY lab_dip.shade_recipe DROP CONSTRAINT shade_recipe_created_by_users_uuid_fk;
       lab_dip          postgres    false    237    264    5385            �           2606    305739 @   shade_recipe_entry shade_recipe_entry_material_uuid_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY lab_dip.shade_recipe_entry
    ADD CONSTRAINT shade_recipe_entry_material_uuid_info_uuid_fk FOREIGN KEY (material_uuid) REFERENCES material.info(uuid);
 k   ALTER TABLE ONLY lab_dip.shade_recipe_entry DROP CONSTRAINT shade_recipe_entry_material_uuid_info_uuid_fk;
       lab_dip          postgres    false    266    265    5447            �           2606    305744 L   shade_recipe_entry shade_recipe_entry_shade_recipe_uuid_shade_recipe_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY lab_dip.shade_recipe_entry
    ADD CONSTRAINT shade_recipe_entry_shade_recipe_uuid_shade_recipe_uuid_fk FOREIGN KEY (shade_recipe_uuid) REFERENCES lab_dip.shade_recipe(uuid);
 w   ALTER TABLE ONLY lab_dip.shade_recipe_entry DROP CONSTRAINT shade_recipe_entry_shade_recipe_uuid_shade_recipe_uuid_fk;
       lab_dip          postgres    false    265    5443    264            �           2606    305749 "   info info_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.info
    ADD CONSTRAINT info_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 N   ALTER TABLE ONLY material.info DROP CONSTRAINT info_created_by_users_uuid_fk;
       material          postgres    false    266    5385    237            �           2606    305754 &   info info_section_uuid_section_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.info
    ADD CONSTRAINT info_section_uuid_section_uuid_fk FOREIGN KEY (section_uuid) REFERENCES material.section(uuid);
 R   ALTER TABLE ONLY material.info DROP CONSTRAINT info_section_uuid_section_uuid_fk;
       material          postgres    false    267    5449    266            �           2606    305759     info info_type_uuid_type_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.info
    ADD CONSTRAINT info_type_uuid_type_uuid_fk FOREIGN KEY (type_uuid) REFERENCES material.type(uuid);
 L   ALTER TABLE ONLY material.info DROP CONSTRAINT info_type_uuid_type_uuid_fk;
       material          postgres    false    271    266    5457            �           2606    305764 (   section section_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.section
    ADD CONSTRAINT section_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 T   ALTER TABLE ONLY material.section DROP CONSTRAINT section_created_by_users_uuid_fk;
       material          postgres    false    237    267    5385            �           2606    305769 &   stock stock_material_uuid_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.stock
    ADD CONSTRAINT stock_material_uuid_info_uuid_fk FOREIGN KEY (material_uuid) REFERENCES material.info(uuid);
 R   ALTER TABLE ONLY material.stock DROP CONSTRAINT stock_material_uuid_info_uuid_fk;
       material          postgres    false    266    268    5447            �           2606    305774 2   stock_to_sfg stock_to_sfg_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.stock_to_sfg
    ADD CONSTRAINT stock_to_sfg_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 ^   ALTER TABLE ONLY material.stock_to_sfg DROP CONSTRAINT stock_to_sfg_created_by_users_uuid_fk;
       material          postgres    false    237    269    5385            �           2606    305779 4   stock_to_sfg stock_to_sfg_material_uuid_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.stock_to_sfg
    ADD CONSTRAINT stock_to_sfg_material_uuid_info_uuid_fk FOREIGN KEY (material_uuid) REFERENCES material.info(uuid);
 `   ALTER TABLE ONLY material.stock_to_sfg DROP CONSTRAINT stock_to_sfg_material_uuid_info_uuid_fk;
       material          postgres    false    266    269    5447                        2606    305784 >   stock_to_sfg stock_to_sfg_order_entry_uuid_order_entry_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.stock_to_sfg
    ADD CONSTRAINT stock_to_sfg_order_entry_uuid_order_entry_uuid_fk FOREIGN KEY (order_entry_uuid) REFERENCES zipper.order_entry(uuid);
 j   ALTER TABLE ONLY material.stock_to_sfg DROP CONSTRAINT stock_to_sfg_order_entry_uuid_order_entry_uuid_fk;
       material          postgres    false    246    269    5413                       2606    305789     trx trx_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.trx
    ADD CONSTRAINT trx_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 L   ALTER TABLE ONLY material.trx DROP CONSTRAINT trx_created_by_users_uuid_fk;
       material          postgres    false    237    270    5385                       2606    305794 "   trx trx_material_uuid_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.trx
    ADD CONSTRAINT trx_material_uuid_info_uuid_fk FOREIGN KEY (material_uuid) REFERENCES material.info(uuid);
 N   ALTER TABLE ONLY material.trx DROP CONSTRAINT trx_material_uuid_info_uuid_fk;
       material          postgres    false    266    270    5447                       2606    305799 "   type type_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.type
    ADD CONSTRAINT type_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 N   ALTER TABLE ONLY material.type DROP CONSTRAINT type_created_by_users_uuid_fk;
       material          postgres    false    271    5385    237                       2606    305804 "   used used_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.used
    ADD CONSTRAINT used_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 N   ALTER TABLE ONLY material.used DROP CONSTRAINT used_created_by_users_uuid_fk;
       material          postgres    false    5385    272    237                       2606    305809 $   used used_material_uuid_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY material.used
    ADD CONSTRAINT used_material_uuid_info_uuid_fk FOREIGN KEY (material_uuid) REFERENCES material.info(uuid);
 P   ALTER TABLE ONLY material.used DROP CONSTRAINT used_material_uuid_info_uuid_fk;
       material          postgres    false    272    266    5447            �           2606    305814 $   buyer buyer_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.buyer
    ADD CONSTRAINT buyer_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 N   ALTER TABLE ONLY public.buyer DROP CONSTRAINT buyer_created_by_users_uuid_fk;
       public          postgres    false    5385    238    237            �           2606    305819 (   factory factory_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.factory
    ADD CONSTRAINT factory_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 R   ALTER TABLE ONLY public.factory DROP CONSTRAINT factory_created_by_users_uuid_fk;
       public          postgres    false    239    5385    237            �           2606    305824 (   factory factory_party_uuid_party_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.factory
    ADD CONSTRAINT factory_party_uuid_party_uuid_fk FOREIGN KEY (party_uuid) REFERENCES public.party(uuid);
 R   ALTER TABLE ONLY public.factory DROP CONSTRAINT factory_party_uuid_party_uuid_fk;
       public          postgres    false    5405    239    242                       2606    305829 (   machine machine_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.machine
    ADD CONSTRAINT machine_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 R   ALTER TABLE ONLY public.machine DROP CONSTRAINT machine_created_by_users_uuid_fk;
       public          postgres    false    5385    273    237            �           2606    305834 ,   marketing marketing_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.marketing
    ADD CONSTRAINT marketing_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 V   ALTER TABLE ONLY public.marketing DROP CONSTRAINT marketing_created_by_users_uuid_fk;
       public          postgres    false    5385    240    237            �           2606    305839 +   marketing marketing_user_uuid_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.marketing
    ADD CONSTRAINT marketing_user_uuid_users_uuid_fk FOREIGN KEY (user_uuid) REFERENCES hr.users(uuid);
 U   ALTER TABLE ONLY public.marketing DROP CONSTRAINT marketing_user_uuid_users_uuid_fk;
       public          postgres    false    237    5385    240            �           2606    305844 2   merchandiser merchandiser_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.merchandiser
    ADD CONSTRAINT merchandiser_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 \   ALTER TABLE ONLY public.merchandiser DROP CONSTRAINT merchandiser_created_by_users_uuid_fk;
       public          postgres    false    237    241    5385            �           2606    305849 2   merchandiser merchandiser_party_uuid_party_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.merchandiser
    ADD CONSTRAINT merchandiser_party_uuid_party_uuid_fk FOREIGN KEY (party_uuid) REFERENCES public.party(uuid);
 \   ALTER TABLE ONLY public.merchandiser DROP CONSTRAINT merchandiser_party_uuid_party_uuid_fk;
       public          postgres    false    242    241    5405            �           2606    305854 $   party party_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.party
    ADD CONSTRAINT party_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 N   ALTER TABLE ONLY public.party DROP CONSTRAINT party_created_by_users_uuid_fk;
       public          postgres    false    242    237    5385                       2606    305859 0   description description_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY purchase.description
    ADD CONSTRAINT description_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 \   ALTER TABLE ONLY purchase.description DROP CONSTRAINT description_created_by_users_uuid_fk;
       purchase          postgres    false    5385    276    237                       2606    305864 2   description description_vendor_uuid_vendor_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY purchase.description
    ADD CONSTRAINT description_vendor_uuid_vendor_uuid_fk FOREIGN KEY (vendor_uuid) REFERENCES purchase.vendor(uuid);
 ^   ALTER TABLE ONLY purchase.description DROP CONSTRAINT description_vendor_uuid_vendor_uuid_fk;
       purchase          postgres    false    278    276    5469            	           2606    305869 &   entry entry_material_uuid_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY purchase.entry
    ADD CONSTRAINT entry_material_uuid_info_uuid_fk FOREIGN KEY (material_uuid) REFERENCES material.info(uuid);
 R   ALTER TABLE ONLY purchase.entry DROP CONSTRAINT entry_material_uuid_info_uuid_fk;
       purchase          postgres    false    277    5447    266            
           2606    305874 9   entry entry_purchase_description_uuid_description_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY purchase.entry
    ADD CONSTRAINT entry_purchase_description_uuid_description_uuid_fk FOREIGN KEY (purchase_description_uuid) REFERENCES purchase.description(uuid);
 e   ALTER TABLE ONLY purchase.entry DROP CONSTRAINT entry_purchase_description_uuid_description_uuid_fk;
       purchase          postgres    false    5465    276    277                       2606    305879 &   vendor vendor_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY purchase.vendor
    ADD CONSTRAINT vendor_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 R   ALTER TABLE ONLY purchase.vendor DROP CONSTRAINT vendor_created_by_users_uuid_fk;
       purchase          postgres    false    5385    278    237                       2606    305884 6   assembly_stock assembly_stock_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.assembly_stock
    ADD CONSTRAINT assembly_stock_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 `   ALTER TABLE ONLY slider.assembly_stock DROP CONSTRAINT assembly_stock_created_by_users_uuid_fk;
       slider          postgres    false    237    279    5385                       2606    305889 G   assembly_stock assembly_stock_die_casting_body_uuid_die_casting_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.assembly_stock
    ADD CONSTRAINT assembly_stock_die_casting_body_uuid_die_casting_uuid_fk FOREIGN KEY (die_casting_body_uuid) REFERENCES slider.die_casting(uuid);
 q   ALTER TABLE ONLY slider.assembly_stock DROP CONSTRAINT assembly_stock_die_casting_body_uuid_die_casting_uuid_fk;
       slider          postgres    false    279    5475    281                       2606    305894 F   assembly_stock assembly_stock_die_casting_cap_uuid_die_casting_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.assembly_stock
    ADD CONSTRAINT assembly_stock_die_casting_cap_uuid_die_casting_uuid_fk FOREIGN KEY (die_casting_cap_uuid) REFERENCES slider.die_casting(uuid);
 p   ALTER TABLE ONLY slider.assembly_stock DROP CONSTRAINT assembly_stock_die_casting_cap_uuid_die_casting_uuid_fk;
       slider          postgres    false    281    279    5475                       2606    305899 G   assembly_stock assembly_stock_die_casting_link_uuid_die_casting_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.assembly_stock
    ADD CONSTRAINT assembly_stock_die_casting_link_uuid_die_casting_uuid_fk FOREIGN KEY (die_casting_link_uuid) REFERENCES slider.die_casting(uuid);
 q   ALTER TABLE ONLY slider.assembly_stock DROP CONSTRAINT assembly_stock_die_casting_link_uuid_die_casting_uuid_fk;
       slider          postgres    false    281    5475    279                       2606    305904 I   assembly_stock assembly_stock_die_casting_puller_uuid_die_casting_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.assembly_stock
    ADD CONSTRAINT assembly_stock_die_casting_puller_uuid_die_casting_uuid_fk FOREIGN KEY (die_casting_puller_uuid) REFERENCES slider.die_casting(uuid);
 s   ALTER TABLE ONLY slider.assembly_stock DROP CONSTRAINT assembly_stock_die_casting_puller_uuid_die_casting_uuid_fk;
       slider          postgres    false    5475    281    279                       2606    305909 B   coloring_transaction coloring_transaction_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.coloring_transaction
    ADD CONSTRAINT coloring_transaction_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 l   ALTER TABLE ONLY slider.coloring_transaction DROP CONSTRAINT coloring_transaction_created_by_users_uuid_fk;
       slider          postgres    false    280    5385    237                       2606    305914 L   coloring_transaction coloring_transaction_order_info_uuid_order_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.coloring_transaction
    ADD CONSTRAINT coloring_transaction_order_info_uuid_order_info_uuid_fk FOREIGN KEY (order_info_uuid) REFERENCES zipper.order_info(uuid);
 v   ALTER TABLE ONLY slider.coloring_transaction DROP CONSTRAINT coloring_transaction_order_info_uuid_order_info_uuid_fk;
       slider          postgres    false    248    280    5415                       2606    305919 B   coloring_transaction coloring_transaction_stock_uuid_stock_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.coloring_transaction
    ADD CONSTRAINT coloring_transaction_stock_uuid_stock_uuid_fk FOREIGN KEY (stock_uuid) REFERENCES slider.stock(uuid);
 l   ALTER TABLE ONLY slider.coloring_transaction DROP CONSTRAINT coloring_transaction_stock_uuid_stock_uuid_fk;
       slider          postgres    false    280    5409    244                       2606    305924 0   die_casting die_casting_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting
    ADD CONSTRAINT die_casting_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 Z   ALTER TABLE ONLY slider.die_casting DROP CONSTRAINT die_casting_created_by_users_uuid_fk;
       slider          postgres    false    281    237    5385                       2606    305929 3   die_casting die_casting_end_type_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting
    ADD CONSTRAINT die_casting_end_type_properties_uuid_fk FOREIGN KEY (end_type) REFERENCES public.properties(uuid);
 ]   ALTER TABLE ONLY slider.die_casting DROP CONSTRAINT die_casting_end_type_properties_uuid_fk;
       slider          postgres    false    5407    281    243                       2606    305934 /   die_casting die_casting_item_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting
    ADD CONSTRAINT die_casting_item_properties_uuid_fk FOREIGN KEY (item) REFERENCES public.properties(uuid);
 Y   ALTER TABLE ONLY slider.die_casting DROP CONSTRAINT die_casting_item_properties_uuid_fk;
       slider          postgres    false    281    243    5407                       2606    305939 4   die_casting die_casting_logo_type_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting
    ADD CONSTRAINT die_casting_logo_type_properties_uuid_fk FOREIGN KEY (logo_type) REFERENCES public.properties(uuid);
 ^   ALTER TABLE ONLY slider.die_casting DROP CONSTRAINT die_casting_logo_type_properties_uuid_fk;
       slider          postgres    false    5407    281    243                       2606    305944 F   die_casting_production die_casting_production_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting_production
    ADD CONSTRAINT die_casting_production_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 p   ALTER TABLE ONLY slider.die_casting_production DROP CONSTRAINT die_casting_production_created_by_users_uuid_fk;
       slider          postgres    false    5385    282    237                       2606    305949 R   die_casting_production die_casting_production_die_casting_uuid_die_casting_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting_production
    ADD CONSTRAINT die_casting_production_die_casting_uuid_die_casting_uuid_fk FOREIGN KEY (die_casting_uuid) REFERENCES slider.die_casting(uuid);
 |   ALTER TABLE ONLY slider.die_casting_production DROP CONSTRAINT die_casting_production_die_casting_uuid_die_casting_uuid_fk;
       slider          postgres    false    5475    281    282                       2606    305954 V   die_casting_production die_casting_production_order_description_uuid_order_description    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting_production
    ADD CONSTRAINT die_casting_production_order_description_uuid_order_description FOREIGN KEY (order_description_uuid) REFERENCES zipper.order_description(uuid);
 �   ALTER TABLE ONLY slider.die_casting_production DROP CONSTRAINT die_casting_production_order_description_uuid_order_description;
       slider          postgres    false    245    282    5411                       2606    305959 6   die_casting die_casting_puller_type_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting
    ADD CONSTRAINT die_casting_puller_type_properties_uuid_fk FOREIGN KEY (puller_type) REFERENCES public.properties(uuid);
 `   ALTER TABLE ONLY slider.die_casting DROP CONSTRAINT die_casting_puller_type_properties_uuid_fk;
       slider          postgres    false    281    5407    243                       2606    305964 <   die_casting die_casting_slider_body_shape_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting
    ADD CONSTRAINT die_casting_slider_body_shape_properties_uuid_fk FOREIGN KEY (slider_body_shape) REFERENCES public.properties(uuid);
 f   ALTER TABLE ONLY slider.die_casting DROP CONSTRAINT die_casting_slider_body_shape_properties_uuid_fk;
       slider          postgres    false    281    5407    243                       2606    305969 6   die_casting die_casting_slider_link_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting
    ADD CONSTRAINT die_casting_slider_link_properties_uuid_fk FOREIGN KEY (slider_link) REFERENCES public.properties(uuid);
 `   ALTER TABLE ONLY slider.die_casting DROP CONSTRAINT die_casting_slider_link_properties_uuid_fk;
       slider          postgres    false    5407    243    281                       2606    305974 ]   die_casting_to_assembly_stock die_casting_to_assembly_stock_assembly_stock_uuid_assembly_stoc    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting_to_assembly_stock
    ADD CONSTRAINT die_casting_to_assembly_stock_assembly_stock_uuid_assembly_stoc FOREIGN KEY (assembly_stock_uuid) REFERENCES slider.assembly_stock(uuid);
 �   ALTER TABLE ONLY slider.die_casting_to_assembly_stock DROP CONSTRAINT die_casting_to_assembly_stock_assembly_stock_uuid_assembly_stoc;
       slider          postgres    false    5471    279    283                        2606    305979 T   die_casting_to_assembly_stock die_casting_to_assembly_stock_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting_to_assembly_stock
    ADD CONSTRAINT die_casting_to_assembly_stock_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 ~   ALTER TABLE ONLY slider.die_casting_to_assembly_stock DROP CONSTRAINT die_casting_to_assembly_stock_created_by_users_uuid_fk;
       slider          postgres    false    237    5385    283            !           2606    305984 H   die_casting_transaction die_casting_transaction_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting_transaction
    ADD CONSTRAINT die_casting_transaction_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 r   ALTER TABLE ONLY slider.die_casting_transaction DROP CONSTRAINT die_casting_transaction_created_by_users_uuid_fk;
       slider          postgres    false    5385    237    284            "           2606    305989 T   die_casting_transaction die_casting_transaction_die_casting_uuid_die_casting_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting_transaction
    ADD CONSTRAINT die_casting_transaction_die_casting_uuid_die_casting_uuid_fk FOREIGN KEY (die_casting_uuid) REFERENCES slider.die_casting(uuid);
 ~   ALTER TABLE ONLY slider.die_casting_transaction DROP CONSTRAINT die_casting_transaction_die_casting_uuid_die_casting_uuid_fk;
       slider          postgres    false    284    5475    281            #           2606    305994 H   die_casting_transaction die_casting_transaction_stock_uuid_stock_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting_transaction
    ADD CONSTRAINT die_casting_transaction_stock_uuid_stock_uuid_fk FOREIGN KEY (stock_uuid) REFERENCES slider.stock(uuid);
 r   ALTER TABLE ONLY slider.die_casting_transaction DROP CONSTRAINT die_casting_transaction_stock_uuid_stock_uuid_fk;
       slider          postgres    false    244    5409    284                       2606    305999 8   die_casting die_casting_zipper_number_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.die_casting
    ADD CONSTRAINT die_casting_zipper_number_properties_uuid_fk FOREIGN KEY (zipper_number) REFERENCES public.properties(uuid);
 b   ALTER TABLE ONLY slider.die_casting DROP CONSTRAINT die_casting_zipper_number_properties_uuid_fk;
       slider          postgres    false    281    5407    243            $           2606    306004 .   production production_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.production
    ADD CONSTRAINT production_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 X   ALTER TABLE ONLY slider.production DROP CONSTRAINT production_created_by_users_uuid_fk;
       slider          postgres    false    237    5385    285            %           2606    306009 .   production production_stock_uuid_stock_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.production
    ADD CONSTRAINT production_stock_uuid_stock_uuid_fk FOREIGN KEY (stock_uuid) REFERENCES slider.stock(uuid);
 X   ALTER TABLE ONLY slider.production DROP CONSTRAINT production_stock_uuid_stock_uuid_fk;
       slider          postgres    false    244    285    5409            �           2606    306014 <   stock stock_order_description_uuid_order_description_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.stock
    ADD CONSTRAINT stock_order_description_uuid_order_description_uuid_fk FOREIGN KEY (order_description_uuid) REFERENCES zipper.order_description(uuid);
 f   ALTER TABLE ONLY slider.stock DROP CONSTRAINT stock_order_description_uuid_order_description_uuid_fk;
       slider          postgres    false    245    244    5411            &           2606    306019 B   transaction transaction_assembly_stock_uuid_assembly_stock_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.transaction
    ADD CONSTRAINT transaction_assembly_stock_uuid_assembly_stock_uuid_fk FOREIGN KEY (assembly_stock_uuid) REFERENCES slider.assembly_stock(uuid);
 l   ALTER TABLE ONLY slider.transaction DROP CONSTRAINT transaction_assembly_stock_uuid_assembly_stock_uuid_fk;
       slider          postgres    false    279    286    5471            '           2606    306024 0   transaction transaction_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.transaction
    ADD CONSTRAINT transaction_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 Z   ALTER TABLE ONLY slider.transaction DROP CONSTRAINT transaction_created_by_users_uuid_fk;
       slider          postgres    false    237    286    5385            (           2606    306029 0   transaction transaction_stock_uuid_stock_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.transaction
    ADD CONSTRAINT transaction_stock_uuid_stock_uuid_fk FOREIGN KEY (stock_uuid) REFERENCES slider.stock(uuid);
 Z   ALTER TABLE ONLY slider.transaction DROP CONSTRAINT transaction_stock_uuid_stock_uuid_fk;
       slider          postgres    false    244    286    5409            )           2606    306034 <   trx_against_stock trx_against_stock_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.trx_against_stock
    ADD CONSTRAINT trx_against_stock_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 f   ALTER TABLE ONLY slider.trx_against_stock DROP CONSTRAINT trx_against_stock_created_by_users_uuid_fk;
       slider          postgres    false    237    287    5385            *           2606    306039 H   trx_against_stock trx_against_stock_die_casting_uuid_die_casting_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY slider.trx_against_stock
    ADD CONSTRAINT trx_against_stock_die_casting_uuid_die_casting_uuid_fk FOREIGN KEY (die_casting_uuid) REFERENCES slider.die_casting(uuid);
 r   ALTER TABLE ONLY slider.trx_against_stock DROP CONSTRAINT trx_against_stock_die_casting_uuid_die_casting_uuid_fk;
       slider          postgres    false    281    287    5475            +           2606    306044 +   batch batch_coning_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch
    ADD CONSTRAINT batch_coning_created_by_users_uuid_fk FOREIGN KEY (coning_created_by) REFERENCES hr.users(uuid);
 U   ALTER TABLE ONLY thread.batch DROP CONSTRAINT batch_coning_created_by_users_uuid_fk;
       thread          postgres    false    289    5385    237            ,           2606    306049 $   batch batch_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch
    ADD CONSTRAINT batch_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 N   ALTER TABLE ONLY thread.batch DROP CONSTRAINT batch_created_by_users_uuid_fk;
       thread          postgres    false    289    5385    237            -           2606    306054 +   batch batch_dyeing_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch
    ADD CONSTRAINT batch_dyeing_created_by_users_uuid_fk FOREIGN KEY (dyeing_created_by) REFERENCES hr.users(uuid);
 U   ALTER TABLE ONLY thread.batch DROP CONSTRAINT batch_dyeing_created_by_users_uuid_fk;
       thread          postgres    false    289    237    5385            .           2606    306059 )   batch batch_dyeing_operator_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch
    ADD CONSTRAINT batch_dyeing_operator_users_uuid_fk FOREIGN KEY (dyeing_operator) REFERENCES hr.users(uuid);
 S   ALTER TABLE ONLY thread.batch DROP CONSTRAINT batch_dyeing_operator_users_uuid_fk;
       thread          postgres    false    289    237    5385            /           2606    306064 +   batch batch_dyeing_supervisor_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch
    ADD CONSTRAINT batch_dyeing_supervisor_users_uuid_fk FOREIGN KEY (dyeing_supervisor) REFERENCES hr.users(uuid);
 U   ALTER TABLE ONLY thread.batch DROP CONSTRAINT batch_dyeing_supervisor_users_uuid_fk;
       thread          postgres    false    237    289    5385            4           2606    306069 0   batch_entry batch_entry_batch_uuid_batch_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch_entry
    ADD CONSTRAINT batch_entry_batch_uuid_batch_uuid_fk FOREIGN KEY (batch_uuid) REFERENCES thread.batch(uuid);
 Z   ALTER TABLE ONLY thread.batch_entry DROP CONSTRAINT batch_entry_batch_uuid_batch_uuid_fk;
       thread          postgres    false    289    5489    290            5           2606    306074 <   batch_entry batch_entry_order_entry_uuid_order_entry_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch_entry
    ADD CONSTRAINT batch_entry_order_entry_uuid_order_entry_uuid_fk FOREIGN KEY (order_entry_uuid) REFERENCES thread.order_entry(uuid);
 f   ALTER TABLE ONLY thread.batch_entry DROP CONSTRAINT batch_entry_order_entry_uuid_order_entry_uuid_fk;
       thread          postgres    false    290    298    5505            6           2606    306079 R   batch_entry_production batch_entry_production_batch_entry_uuid_batch_entry_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch_entry_production
    ADD CONSTRAINT batch_entry_production_batch_entry_uuid_batch_entry_uuid_fk FOREIGN KEY (batch_entry_uuid) REFERENCES thread.batch_entry(uuid);
 |   ALTER TABLE ONLY thread.batch_entry_production DROP CONSTRAINT batch_entry_production_batch_entry_uuid_batch_entry_uuid_fk;
       thread          postgres    false    5491    290    291            7           2606    306084 F   batch_entry_production batch_entry_production_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch_entry_production
    ADD CONSTRAINT batch_entry_production_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 p   ALTER TABLE ONLY thread.batch_entry_production DROP CONSTRAINT batch_entry_production_created_by_users_uuid_fk;
       thread          postgres    false    5385    291    237            8           2606    306089 D   batch_entry_trx batch_entry_trx_batch_entry_uuid_batch_entry_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch_entry_trx
    ADD CONSTRAINT batch_entry_trx_batch_entry_uuid_batch_entry_uuid_fk FOREIGN KEY (batch_entry_uuid) REFERENCES thread.batch_entry(uuid);
 n   ALTER TABLE ONLY thread.batch_entry_trx DROP CONSTRAINT batch_entry_trx_batch_entry_uuid_batch_entry_uuid_fk;
       thread          postgres    false    292    5491    290            9           2606    306094 8   batch_entry_trx batch_entry_trx_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch_entry_trx
    ADD CONSTRAINT batch_entry_trx_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 b   ALTER TABLE ONLY thread.batch_entry_trx DROP CONSTRAINT batch_entry_trx_created_by_users_uuid_fk;
       thread          postgres    false    5385    292    237            0           2606    306099 (   batch batch_lab_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch
    ADD CONSTRAINT batch_lab_created_by_users_uuid_fk FOREIGN KEY (lab_created_by) REFERENCES hr.users(uuid);
 R   ALTER TABLE ONLY thread.batch DROP CONSTRAINT batch_lab_created_by_users_uuid_fk;
       thread          postgres    false    289    237    5385            1           2606    306104 (   batch batch_machine_uuid_machine_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch
    ADD CONSTRAINT batch_machine_uuid_machine_uuid_fk FOREIGN KEY (machine_uuid) REFERENCES public.machine(uuid);
 R   ALTER TABLE ONLY thread.batch DROP CONSTRAINT batch_machine_uuid_machine_uuid_fk;
       thread          postgres    false    289    273    5461            2           2606    306109 !   batch batch_pass_by_users_uuid_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY thread.batch
    ADD CONSTRAINT batch_pass_by_users_uuid_fk FOREIGN KEY (pass_by) REFERENCES hr.users(uuid);
 K   ALTER TABLE ONLY thread.batch DROP CONSTRAINT batch_pass_by_users_uuid_fk;
       thread          postgres    false    237    5385    289            3           2606    306114 /   batch batch_yarn_issue_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.batch
    ADD CONSTRAINT batch_yarn_issue_created_by_users_uuid_fk FOREIGN KEY (yarn_issue_created_by) REFERENCES hr.users(uuid);
 Y   ALTER TABLE ONLY thread.batch DROP CONSTRAINT batch_yarn_issue_created_by_users_uuid_fk;
       thread          postgres    false    5385    289    237            :           2606    306119 '   challan challan_assign_to_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.challan
    ADD CONSTRAINT challan_assign_to_users_uuid_fk FOREIGN KEY (assign_to) REFERENCES hr.users(uuid);
 Q   ALTER TABLE ONLY thread.challan DROP CONSTRAINT challan_assign_to_users_uuid_fk;
       thread          postgres    false    294    237    5385            ;           2606    306124 (   challan challan_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.challan
    ADD CONSTRAINT challan_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 R   ALTER TABLE ONLY thread.challan DROP CONSTRAINT challan_created_by_users_uuid_fk;
       thread          postgres    false    237    294    5385            =           2606    306129 8   challan_entry challan_entry_challan_uuid_challan_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.challan_entry
    ADD CONSTRAINT challan_entry_challan_uuid_challan_uuid_fk FOREIGN KEY (challan_uuid) REFERENCES thread.challan(uuid);
 b   ALTER TABLE ONLY thread.challan_entry DROP CONSTRAINT challan_entry_challan_uuid_challan_uuid_fk;
       thread          postgres    false    5497    294    295            >           2606    306134 4   challan_entry challan_entry_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.challan_entry
    ADD CONSTRAINT challan_entry_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 ^   ALTER TABLE ONLY thread.challan_entry DROP CONSTRAINT challan_entry_created_by_users_uuid_fk;
       thread          postgres    false    237    295    5385            ?           2606    306139 @   challan_entry challan_entry_order_entry_uuid_order_entry_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.challan_entry
    ADD CONSTRAINT challan_entry_order_entry_uuid_order_entry_uuid_fk FOREIGN KEY (order_entry_uuid) REFERENCES thread.order_entry(uuid);
 j   ALTER TABLE ONLY thread.challan_entry DROP CONSTRAINT challan_entry_order_entry_uuid_order_entry_uuid_fk;
       thread          postgres    false    5505    295    298            <           2606    306144 2   challan challan_order_info_uuid_order_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.challan
    ADD CONSTRAINT challan_order_info_uuid_order_info_uuid_fk FOREIGN KEY (order_info_uuid) REFERENCES thread.order_info(uuid);
 \   ALTER TABLE ONLY thread.challan DROP CONSTRAINT challan_order_info_uuid_order_info_uuid_fk;
       thread          postgres    false    5507    294    300            @           2606    306149 2   count_length count_length_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.count_length
    ADD CONSTRAINT count_length_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 \   ALTER TABLE ONLY thread.count_length DROP CONSTRAINT count_length_created_by_users_uuid_fk;
       thread          postgres    false    5385    237    296            A           2606    306154 4   dyes_category dyes_category_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.dyes_category
    ADD CONSTRAINT dyes_category_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 ^   ALTER TABLE ONLY thread.dyes_category DROP CONSTRAINT dyes_category_created_by_users_uuid_fk;
       thread          postgres    false    297    237    5385            B           2606    306159 >   order_entry order_entry_count_length_uuid_count_length_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.order_entry
    ADD CONSTRAINT order_entry_count_length_uuid_count_length_uuid_fk FOREIGN KEY (count_length_uuid) REFERENCES thread.count_length(uuid);
 h   ALTER TABLE ONLY thread.order_entry DROP CONSTRAINT order_entry_count_length_uuid_count_length_uuid_fk;
       thread          postgres    false    296    5501    298            C           2606    306164 0   order_entry order_entry_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.order_entry
    ADD CONSTRAINT order_entry_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 Z   ALTER TABLE ONLY thread.order_entry DROP CONSTRAINT order_entry_created_by_users_uuid_fk;
       thread          postgres    false    298    237    5385            D           2606    306169 :   order_entry order_entry_order_info_uuid_order_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.order_entry
    ADD CONSTRAINT order_entry_order_info_uuid_order_info_uuid_fk FOREIGN KEY (order_info_uuid) REFERENCES thread.order_info(uuid);
 d   ALTER TABLE ONLY thread.order_entry DROP CONSTRAINT order_entry_order_info_uuid_order_info_uuid_fk;
       thread          postgres    false    5507    300    298            E           2606    306174 2   order_entry order_entry_recipe_uuid_recipe_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.order_entry
    ADD CONSTRAINT order_entry_recipe_uuid_recipe_uuid_fk FOREIGN KEY (recipe_uuid) REFERENCES lab_dip.recipe(uuid);
 \   ALTER TABLE ONLY thread.order_entry DROP CONSTRAINT order_entry_recipe_uuid_recipe_uuid_fk;
       thread          postgres    false    5439    298    260            F           2606    306179 .   order_info order_info_buyer_uuid_buyer_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.order_info
    ADD CONSTRAINT order_info_buyer_uuid_buyer_uuid_fk FOREIGN KEY (buyer_uuid) REFERENCES public.buyer(uuid);
 X   ALTER TABLE ONLY thread.order_info DROP CONSTRAINT order_info_buyer_uuid_buyer_uuid_fk;
       thread          postgres    false    238    5389    300            G           2606    306184 .   order_info order_info_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.order_info
    ADD CONSTRAINT order_info_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 X   ALTER TABLE ONLY thread.order_info DROP CONSTRAINT order_info_created_by_users_uuid_fk;
       thread          postgres    false    5385    300    237            H           2606    306189 2   order_info order_info_factory_uuid_factory_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.order_info
    ADD CONSTRAINT order_info_factory_uuid_factory_uuid_fk FOREIGN KEY (factory_uuid) REFERENCES public.factory(uuid);
 \   ALTER TABLE ONLY thread.order_info DROP CONSTRAINT order_info_factory_uuid_factory_uuid_fk;
       thread          postgres    false    5393    300    239            I           2606    306194 6   order_info order_info_marketing_uuid_marketing_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.order_info
    ADD CONSTRAINT order_info_marketing_uuid_marketing_uuid_fk FOREIGN KEY (marketing_uuid) REFERENCES public.marketing(uuid);
 `   ALTER TABLE ONLY thread.order_info DROP CONSTRAINT order_info_marketing_uuid_marketing_uuid_fk;
       thread          postgres    false    5397    300    240            J           2606    306199 <   order_info order_info_merchandiser_uuid_merchandiser_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.order_info
    ADD CONSTRAINT order_info_merchandiser_uuid_merchandiser_uuid_fk FOREIGN KEY (merchandiser_uuid) REFERENCES public.merchandiser(uuid);
 f   ALTER TABLE ONLY thread.order_info DROP CONSTRAINT order_info_merchandiser_uuid_merchandiser_uuid_fk;
       thread          postgres    false    5401    300    241            K           2606    306204 .   order_info order_info_party_uuid_party_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.order_info
    ADD CONSTRAINT order_info_party_uuid_party_uuid_fk FOREIGN KEY (party_uuid) REFERENCES public.party(uuid);
 X   ALTER TABLE ONLY thread.order_info DROP CONSTRAINT order_info_party_uuid_party_uuid_fk;
       thread          postgres    false    242    300    5405            L           2606    306209 *   programs programs_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.programs
    ADD CONSTRAINT programs_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 T   ALTER TABLE ONLY thread.programs DROP CONSTRAINT programs_created_by_users_uuid_fk;
       thread          postgres    false    5385    301    237            M           2606    306214 :   programs programs_dyes_category_uuid_dyes_category_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.programs
    ADD CONSTRAINT programs_dyes_category_uuid_dyes_category_uuid_fk FOREIGN KEY (dyes_category_uuid) REFERENCES thread.dyes_category(uuid);
 d   ALTER TABLE ONLY thread.programs DROP CONSTRAINT programs_dyes_category_uuid_dyes_category_uuid_fk;
       thread          postgres    false    5503    301    297            N           2606    306219 ,   programs programs_material_uuid_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY thread.programs
    ADD CONSTRAINT programs_material_uuid_info_uuid_fk FOREIGN KEY (material_uuid) REFERENCES material.info(uuid);
 V   ALTER TABLE ONLY thread.programs DROP CONSTRAINT programs_material_uuid_info_uuid_fk;
       thread          postgres    false    5447    301    266            O           2606    306224 $   batch batch_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.batch
    ADD CONSTRAINT batch_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 N   ALTER TABLE ONLY zipper.batch DROP CONSTRAINT batch_created_by_users_uuid_fk;
       zipper          postgres    false    5385    302    237            Q           2606    306229 0   batch_entry batch_entry_batch_uuid_batch_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.batch_entry
    ADD CONSTRAINT batch_entry_batch_uuid_batch_uuid_fk FOREIGN KEY (batch_uuid) REFERENCES zipper.batch(uuid);
 Z   ALTER TABLE ONLY zipper.batch_entry DROP CONSTRAINT batch_entry_batch_uuid_batch_uuid_fk;
       zipper          postgres    false    5511    303    302            R           2606    306234 ,   batch_entry batch_entry_sfg_uuid_sfg_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.batch_entry
    ADD CONSTRAINT batch_entry_sfg_uuid_sfg_uuid_fk FOREIGN KEY (sfg_uuid) REFERENCES zipper.sfg(uuid);
 V   ALTER TABLE ONLY zipper.batch_entry DROP CONSTRAINT batch_entry_sfg_uuid_sfg_uuid_fk;
       zipper          postgres    false    5417    303    249            P           2606    306239 (   batch batch_machine_uuid_machine_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.batch
    ADD CONSTRAINT batch_machine_uuid_machine_uuid_fk FOREIGN KEY (machine_uuid) REFERENCES public.machine(uuid);
 R   ALTER TABLE ONLY zipper.batch DROP CONSTRAINT batch_machine_uuid_machine_uuid_fk;
       zipper          postgres    false    273    5461    302            S           2606    306244 F   batch_production batch_production_batch_entry_uuid_batch_entry_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.batch_production
    ADD CONSTRAINT batch_production_batch_entry_uuid_batch_entry_uuid_fk FOREIGN KEY (batch_entry_uuid) REFERENCES zipper.batch_entry(uuid);
 p   ALTER TABLE ONLY zipper.batch_production DROP CONSTRAINT batch_production_batch_entry_uuid_batch_entry_uuid_fk;
       zipper          postgres    false    305    5513    303            T           2606    306249 :   batch_production batch_production_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.batch_production
    ADD CONSTRAINT batch_production_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 d   ALTER TABLE ONLY zipper.batch_production DROP CONSTRAINT batch_production_created_by_users_uuid_fk;
       zipper          postgres    false    305    237    5385            U           2606    306254 D   dyed_tape_transaction dyed_tape_transaction_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.dyed_tape_transaction
    ADD CONSTRAINT dyed_tape_transaction_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 n   ALTER TABLE ONLY zipper.dyed_tape_transaction DROP CONSTRAINT dyed_tape_transaction_created_by_users_uuid_fk;
       zipper          postgres    false    306    5385    237            W           2606    306259 Z   dyed_tape_transaction_from_stock dyed_tape_transaction_from_stock_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.dyed_tape_transaction_from_stock
    ADD CONSTRAINT dyed_tape_transaction_from_stock_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 �   ALTER TABLE ONLY zipper.dyed_tape_transaction_from_stock DROP CONSTRAINT dyed_tape_transaction_from_stock_created_by_users_uuid_fk;
       zipper          postgres    false    5385    237    307            X           2606    306264 `   dyed_tape_transaction_from_stock dyed_tape_transaction_from_stock_order_description_uuid_order_d    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.dyed_tape_transaction_from_stock
    ADD CONSTRAINT dyed_tape_transaction_from_stock_order_description_uuid_order_d FOREIGN KEY (order_description_uuid) REFERENCES zipper.order_description(uuid);
 �   ALTER TABLE ONLY zipper.dyed_tape_transaction_from_stock DROP CONSTRAINT dyed_tape_transaction_from_stock_order_description_uuid_order_d;
       zipper          postgres    false    307    5411    245            Y           2606    306269 `   dyed_tape_transaction_from_stock dyed_tape_transaction_from_stock_tape_coil_uuid_tape_coil_uuid_    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.dyed_tape_transaction_from_stock
    ADD CONSTRAINT dyed_tape_transaction_from_stock_tape_coil_uuid_tape_coil_uuid_ FOREIGN KEY (tape_coil_uuid) REFERENCES zipper.tape_coil(uuid);
 �   ALTER TABLE ONLY zipper.dyed_tape_transaction_from_stock DROP CONSTRAINT dyed_tape_transaction_from_stock_tape_coil_uuid_tape_coil_uuid_;
       zipper          postgres    false    307    5419    250            V           2606    306274 U   dyed_tape_transaction dyed_tape_transaction_order_description_uuid_order_description_    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.dyed_tape_transaction
    ADD CONSTRAINT dyed_tape_transaction_order_description_uuid_order_description_ FOREIGN KEY (order_description_uuid) REFERENCES zipper.order_description(uuid);
    ALTER TABLE ONLY zipper.dyed_tape_transaction DROP CONSTRAINT dyed_tape_transaction_order_description_uuid_order_description_;
       zipper          postgres    false    306    5411    245            Z           2606    306279 H   dying_batch_entry dying_batch_entry_batch_entry_uuid_batch_entry_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.dying_batch_entry
    ADD CONSTRAINT dying_batch_entry_batch_entry_uuid_batch_entry_uuid_fk FOREIGN KEY (batch_entry_uuid) REFERENCES zipper.batch_entry(uuid);
 r   ALTER TABLE ONLY zipper.dying_batch_entry DROP CONSTRAINT dying_batch_entry_batch_entry_uuid_batch_entry_uuid_fk;
       zipper          postgres    false    303    309    5513            [           2606    306284 H   dying_batch_entry dying_batch_entry_dying_batch_uuid_dying_batch_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.dying_batch_entry
    ADD CONSTRAINT dying_batch_entry_dying_batch_uuid_dying_batch_uuid_fk FOREIGN KEY (dying_batch_uuid) REFERENCES zipper.dying_batch(uuid);
 r   ALTER TABLE ONLY zipper.dying_batch_entry DROP CONSTRAINT dying_batch_entry_dying_batch_uuid_dying_batch_uuid_fk;
       zipper          postgres    false    308    5521    309            \           2606    306289 f   material_trx_against_order_description material_trx_against_order_description_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.material_trx_against_order_description
    ADD CONSTRAINT material_trx_against_order_description_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 �   ALTER TABLE ONLY zipper.material_trx_against_order_description DROP CONSTRAINT material_trx_against_order_description_created_by_users_uuid_fk;
       zipper          postgres    false    237    311    5385            ]           2606    306294 f   material_trx_against_order_description material_trx_against_order_description_material_uuid_info_uuid_    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.material_trx_against_order_description
    ADD CONSTRAINT material_trx_against_order_description_material_uuid_info_uuid_ FOREIGN KEY (material_uuid) REFERENCES material.info(uuid);
 �   ALTER TABLE ONLY zipper.material_trx_against_order_description DROP CONSTRAINT material_trx_against_order_description_material_uuid_info_uuid_;
       zipper          postgres    false    5447    311    266            ^           2606    306299 f   material_trx_against_order_description material_trx_against_order_description_order_description_uuid_o    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.material_trx_against_order_description
    ADD CONSTRAINT material_trx_against_order_description_order_description_uuid_o FOREIGN KEY (order_description_uuid) REFERENCES zipper.order_description(uuid);
 �   ALTER TABLE ONLY zipper.material_trx_against_order_description DROP CONSTRAINT material_trx_against_order_description_order_description_uuid_o;
       zipper          postgres    false    245    311    5411            _           2606    306304 B   multi_color_dashboard multi_color_dashboard_coil_uuid_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.multi_color_dashboard
    ADD CONSTRAINT multi_color_dashboard_coil_uuid_info_uuid_fk FOREIGN KEY (coil_uuid) REFERENCES material.info(uuid);
 l   ALTER TABLE ONLY zipper.multi_color_dashboard DROP CONSTRAINT multi_color_dashboard_coil_uuid_info_uuid_fk;
       zipper          postgres    false    266    312    5447            `           2606    306309 U   multi_color_dashboard multi_color_dashboard_order_description_uuid_order_description_    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.multi_color_dashboard
    ADD CONSTRAINT multi_color_dashboard_order_description_uuid_order_description_ FOREIGN KEY (order_description_uuid) REFERENCES zipper.order_description(uuid);
    ALTER TABLE ONLY zipper.multi_color_dashboard DROP CONSTRAINT multi_color_dashboard_order_description_uuid_order_description_;
       zipper          postgres    false    245    312    5411            a           2606    306314 J   multi_color_tape_receive multi_color_tape_receive_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.multi_color_tape_receive
    ADD CONSTRAINT multi_color_tape_receive_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 t   ALTER TABLE ONLY zipper.multi_color_tape_receive DROP CONSTRAINT multi_color_tape_receive_created_by_users_uuid_fk;
       zipper          postgres    false    313    237    5385            b           2606    306319 X   multi_color_tape_receive multi_color_tape_receive_order_description_uuid_order_descripti    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.multi_color_tape_receive
    ADD CONSTRAINT multi_color_tape_receive_order_description_uuid_order_descripti FOREIGN KEY (order_description_uuid) REFERENCES zipper.order_description(uuid);
 �   ALTER TABLE ONLY zipper.multi_color_tape_receive DROP CONSTRAINT multi_color_tape_receive_order_description_uuid_order_descripti;
       zipper          postgres    false    245    5411    313            �           2606    306324 E   order_description order_description_bottom_stopper_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_bottom_stopper_properties_uuid_fk FOREIGN KEY (bottom_stopper) REFERENCES public.properties(uuid);
 o   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_bottom_stopper_properties_uuid_fk;
       zipper          postgres    false    5407    243    245            �           2606    306329 D   order_description order_description_coloring_type_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_coloring_type_properties_uuid_fk FOREIGN KEY (coloring_type) REFERENCES public.properties(uuid);
 n   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_coloring_type_properties_uuid_fk;
       zipper          postgres    false    5407    245    243            �           2606    306334 <   order_description order_description_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 f   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_created_by_users_uuid_fk;
       zipper          postgres    false    237    5385    245            �           2606    306339 ?   order_description order_description_end_type_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_end_type_properties_uuid_fk FOREIGN KEY (end_type) REFERENCES public.properties(uuid);
 i   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_end_type_properties_uuid_fk;
       zipper          postgres    false    5407    243    245            �           2606    306344 ?   order_description order_description_end_user_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_end_user_properties_uuid_fk FOREIGN KEY (end_user) REFERENCES public.properties(uuid);
 i   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_end_user_properties_uuid_fk;
       zipper          postgres    false    5407    245    243            �           2606    306349 ;   order_description order_description_hand_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_hand_properties_uuid_fk FOREIGN KEY (hand) REFERENCES public.properties(uuid);
 e   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_hand_properties_uuid_fk;
       zipper          postgres    false    245    5407    243            �           2606    306354 ;   order_description order_description_item_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_item_properties_uuid_fk FOREIGN KEY (item) REFERENCES public.properties(uuid);
 e   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_item_properties_uuid_fk;
       zipper          postgres    false    245    243    5407            �           2606    306359 G   order_description order_description_light_preference_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_light_preference_properties_uuid_fk FOREIGN KEY (light_preference) REFERENCES public.properties(uuid);
 q   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_light_preference_properties_uuid_fk;
       zipper          postgres    false    243    245    5407            �           2606    306364 @   order_description order_description_lock_type_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_lock_type_properties_uuid_fk FOREIGN KEY (lock_type) REFERENCES public.properties(uuid);
 j   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_lock_type_properties_uuid_fk;
       zipper          postgres    false    243    5407    245            �           2606    306369 @   order_description order_description_logo_type_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_logo_type_properties_uuid_fk FOREIGN KEY (logo_type) REFERENCES public.properties(uuid);
 j   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_logo_type_properties_uuid_fk;
       zipper          postgres    false    5407    243    245            �           2606    306374 D   order_description order_description_nylon_stopper_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_nylon_stopper_properties_uuid_fk FOREIGN KEY (nylon_stopper) REFERENCES public.properties(uuid);
 n   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_nylon_stopper_properties_uuid_fk;
       zipper          postgres    false    243    245    5407            �           2606    306379 F   order_description order_description_order_info_uuid_order_info_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_order_info_uuid_order_info_uuid_fk FOREIGN KEY (order_info_uuid) REFERENCES zipper.order_info(uuid);
 p   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_order_info_uuid_order_info_uuid_fk;
       zipper          postgres    false    245    5415    248            �           2606    306384 C   order_description order_description_puller_color_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_puller_color_properties_uuid_fk FOREIGN KEY (puller_color) REFERENCES public.properties(uuid);
 m   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_puller_color_properties_uuid_fk;
       zipper          postgres    false    243    245    5407            �           2606    306389 B   order_description order_description_puller_type_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_puller_type_properties_uuid_fk FOREIGN KEY (puller_type) REFERENCES public.properties(uuid);
 l   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_puller_type_properties_uuid_fk;
       zipper          postgres    false    245    243    5407            �           2606    306394 H   order_description order_description_slider_body_shape_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_slider_body_shape_properties_uuid_fk FOREIGN KEY (slider_body_shape) REFERENCES public.properties(uuid);
 r   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_slider_body_shape_properties_uuid_fk;
       zipper          postgres    false    243    5407    245            �           2606    306399 B   order_description order_description_slider_link_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_slider_link_properties_uuid_fk FOREIGN KEY (slider_link) REFERENCES public.properties(uuid);
 l   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_slider_link_properties_uuid_fk;
       zipper          postgres    false    243    245    5407            �           2606    306404 =   order_description order_description_slider_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_slider_properties_uuid_fk FOREIGN KEY (slider) REFERENCES public.properties(uuid);
 g   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_slider_properties_uuid_fk;
       zipper          postgres    false    5407    245    243            �           2606    306409 D   order_description order_description_tape_coil_uuid_tape_coil_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_tape_coil_uuid_tape_coil_uuid_fk FOREIGN KEY (tape_coil_uuid) REFERENCES zipper.tape_coil(uuid);
 n   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_tape_coil_uuid_tape_coil_uuid_fk;
       zipper          postgres    false    245    5419    250            �           2606    306414 B   order_description order_description_teeth_color_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_teeth_color_properties_uuid_fk FOREIGN KEY (teeth_color) REFERENCES public.properties(uuid);
 l   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_teeth_color_properties_uuid_fk;
       zipper          postgres    false    243    5407    245            �           2606    306419 A   order_description order_description_teeth_type_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_teeth_type_properties_uuid_fk FOREIGN KEY (teeth_type) REFERENCES public.properties(uuid);
 k   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_teeth_type_properties_uuid_fk;
       zipper          postgres    false    243    245    5407            �           2606    306424 B   order_description order_description_top_stopper_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_top_stopper_properties_uuid_fk FOREIGN KEY (top_stopper) REFERENCES public.properties(uuid);
 l   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_top_stopper_properties_uuid_fk;
       zipper          postgres    false    243    5407    245            �           2606    306429 D   order_description order_description_zipper_number_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_description
    ADD CONSTRAINT order_description_zipper_number_properties_uuid_fk FOREIGN KEY (zipper_number) REFERENCES public.properties(uuid);
 n   ALTER TABLE ONLY zipper.order_description DROP CONSTRAINT order_description_zipper_number_properties_uuid_fk;
       zipper          postgres    false    245    243    5407            �           2606    306434 H   order_entry order_entry_order_description_uuid_order_description_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_entry
    ADD CONSTRAINT order_entry_order_description_uuid_order_description_uuid_fk FOREIGN KEY (order_description_uuid) REFERENCES zipper.order_description(uuid);
 r   ALTER TABLE ONLY zipper.order_entry DROP CONSTRAINT order_entry_order_description_uuid_order_description_uuid_fk;
       zipper          postgres    false    246    5411    245            �           2606    306439 .   order_info order_info_buyer_uuid_buyer_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_info
    ADD CONSTRAINT order_info_buyer_uuid_buyer_uuid_fk FOREIGN KEY (buyer_uuid) REFERENCES public.buyer(uuid);
 X   ALTER TABLE ONLY zipper.order_info DROP CONSTRAINT order_info_buyer_uuid_buyer_uuid_fk;
       zipper          postgres    false    248    238    5389            �           2606    306444 2   order_info order_info_factory_uuid_factory_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_info
    ADD CONSTRAINT order_info_factory_uuid_factory_uuid_fk FOREIGN KEY (factory_uuid) REFERENCES public.factory(uuid);
 \   ALTER TABLE ONLY zipper.order_info DROP CONSTRAINT order_info_factory_uuid_factory_uuid_fk;
       zipper          postgres    false    248    5393    239            �           2606    306449 6   order_info order_info_marketing_uuid_marketing_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_info
    ADD CONSTRAINT order_info_marketing_uuid_marketing_uuid_fk FOREIGN KEY (marketing_uuid) REFERENCES public.marketing(uuid);
 `   ALTER TABLE ONLY zipper.order_info DROP CONSTRAINT order_info_marketing_uuid_marketing_uuid_fk;
       zipper          postgres    false    5397    248    240            �           2606    306454 <   order_info order_info_merchandiser_uuid_merchandiser_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_info
    ADD CONSTRAINT order_info_merchandiser_uuid_merchandiser_uuid_fk FOREIGN KEY (merchandiser_uuid) REFERENCES public.merchandiser(uuid);
 f   ALTER TABLE ONLY zipper.order_info DROP CONSTRAINT order_info_merchandiser_uuid_merchandiser_uuid_fk;
       zipper          postgres    false    248    5401    241            �           2606    306459 .   order_info order_info_party_uuid_party_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.order_info
    ADD CONSTRAINT order_info_party_uuid_party_uuid_fk FOREIGN KEY (party_uuid) REFERENCES public.party(uuid);
 X   ALTER TABLE ONLY zipper.order_info DROP CONSTRAINT order_info_party_uuid_party_uuid_fk;
       zipper          postgres    false    248    242    5405            c           2606    306464 *   planning planning_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.planning
    ADD CONSTRAINT planning_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 T   ALTER TABLE ONLY zipper.planning DROP CONSTRAINT planning_created_by_users_uuid_fk;
       zipper          postgres    false    5385    237    314            d           2606    306469 <   planning_entry planning_entry_planning_week_planning_week_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.planning_entry
    ADD CONSTRAINT planning_entry_planning_week_planning_week_fk FOREIGN KEY (planning_week) REFERENCES zipper.planning(week);
 f   ALTER TABLE ONLY zipper.planning_entry DROP CONSTRAINT planning_entry_planning_week_planning_week_fk;
       zipper          postgres    false    314    315    5531            e           2606    306474 2   planning_entry planning_entry_sfg_uuid_sfg_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.planning_entry
    ADD CONSTRAINT planning_entry_sfg_uuid_sfg_uuid_fk FOREIGN KEY (sfg_uuid) REFERENCES zipper.sfg(uuid);
 \   ALTER TABLE ONLY zipper.planning_entry DROP CONSTRAINT planning_entry_sfg_uuid_sfg_uuid_fk;
       zipper          postgres    false    315    249    5417            �           2606    306479 ,   sfg sfg_order_entry_uuid_order_entry_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.sfg
    ADD CONSTRAINT sfg_order_entry_uuid_order_entry_uuid_fk FOREIGN KEY (order_entry_uuid) REFERENCES zipper.order_entry(uuid);
 V   ALTER TABLE ONLY zipper.sfg DROP CONSTRAINT sfg_order_entry_uuid_order_entry_uuid_fk;
       zipper          postgres    false    249    5413    246            f           2606    306484 6   sfg_production sfg_production_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.sfg_production
    ADD CONSTRAINT sfg_production_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 `   ALTER TABLE ONLY zipper.sfg_production DROP CONSTRAINT sfg_production_created_by_users_uuid_fk;
       zipper          postgres    false    237    5385    316            g           2606    306489 2   sfg_production sfg_production_sfg_uuid_sfg_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.sfg_production
    ADD CONSTRAINT sfg_production_sfg_uuid_sfg_uuid_fk FOREIGN KEY (sfg_uuid) REFERENCES zipper.sfg(uuid);
 \   ALTER TABLE ONLY zipper.sfg_production DROP CONSTRAINT sfg_production_sfg_uuid_sfg_uuid_fk;
       zipper          postgres    false    249    316    5417            �           2606    306494 "   sfg sfg_recipe_uuid_recipe_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.sfg
    ADD CONSTRAINT sfg_recipe_uuid_recipe_uuid_fk FOREIGN KEY (recipe_uuid) REFERENCES lab_dip.recipe(uuid);
 L   ALTER TABLE ONLY zipper.sfg DROP CONSTRAINT sfg_recipe_uuid_recipe_uuid_fk;
       zipper          postgres    false    5439    260    249            h           2606    306499 8   sfg_transaction sfg_transaction_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.sfg_transaction
    ADD CONSTRAINT sfg_transaction_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 b   ALTER TABLE ONLY zipper.sfg_transaction DROP CONSTRAINT sfg_transaction_created_by_users_uuid_fk;
       zipper          postgres    false    5385    317    237            i           2606    306504 4   sfg_transaction sfg_transaction_sfg_uuid_sfg_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.sfg_transaction
    ADD CONSTRAINT sfg_transaction_sfg_uuid_sfg_uuid_fk FOREIGN KEY (sfg_uuid) REFERENCES zipper.sfg(uuid);
 ^   ALTER TABLE ONLY zipper.sfg_transaction DROP CONSTRAINT sfg_transaction_sfg_uuid_sfg_uuid_fk;
       zipper          postgres    false    5417    249    317            j           2606    306509 >   sfg_transaction sfg_transaction_slider_item_uuid_stock_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.sfg_transaction
    ADD CONSTRAINT sfg_transaction_slider_item_uuid_stock_uuid_fk FOREIGN KEY (slider_item_uuid) REFERENCES slider.stock(uuid);
 h   ALTER TABLE ONLY zipper.sfg_transaction DROP CONSTRAINT sfg_transaction_slider_item_uuid_stock_uuid_fk;
       zipper          postgres    false    244    5409    317            �           2606    306514 ,   tape_coil tape_coil_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil
    ADD CONSTRAINT tape_coil_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 V   ALTER TABLE ONLY zipper.tape_coil DROP CONSTRAINT tape_coil_created_by_users_uuid_fk;
       zipper          postgres    false    237    250    5385            �           2606    306519 0   tape_coil tape_coil_item_uuid_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil
    ADD CONSTRAINT tape_coil_item_uuid_properties_uuid_fk FOREIGN KEY (item_uuid) REFERENCES public.properties(uuid);
 Z   ALTER TABLE ONLY zipper.tape_coil DROP CONSTRAINT tape_coil_item_uuid_properties_uuid_fk;
       zipper          postgres    false    250    5407    243            k           2606    306524 B   tape_coil_production tape_coil_production_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil_production
    ADD CONSTRAINT tape_coil_production_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 l   ALTER TABLE ONLY zipper.tape_coil_production DROP CONSTRAINT tape_coil_production_created_by_users_uuid_fk;
       zipper          postgres    false    5385    318    237            l           2606    306529 J   tape_coil_production tape_coil_production_tape_coil_uuid_tape_coil_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil_production
    ADD CONSTRAINT tape_coil_production_tape_coil_uuid_tape_coil_uuid_fk FOREIGN KEY (tape_coil_uuid) REFERENCES zipper.tape_coil(uuid);
 t   ALTER TABLE ONLY zipper.tape_coil_production DROP CONSTRAINT tape_coil_production_tape_coil_uuid_tape_coil_uuid_fk;
       zipper          postgres    false    318    250    5419            m           2606    306534 >   tape_coil_required tape_coil_required_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil_required
    ADD CONSTRAINT tape_coil_required_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 h   ALTER TABLE ONLY zipper.tape_coil_required DROP CONSTRAINT tape_coil_required_created_by_users_uuid_fk;
       zipper          postgres    false    5385    237    319            n           2606    306539 F   tape_coil_required tape_coil_required_end_type_uuid_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil_required
    ADD CONSTRAINT tape_coil_required_end_type_uuid_properties_uuid_fk FOREIGN KEY (end_type_uuid) REFERENCES public.properties(uuid);
 p   ALTER TABLE ONLY zipper.tape_coil_required DROP CONSTRAINT tape_coil_required_end_type_uuid_properties_uuid_fk;
       zipper          postgres    false    319    5407    243            o           2606    306544 B   tape_coil_required tape_coil_required_item_uuid_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil_required
    ADD CONSTRAINT tape_coil_required_item_uuid_properties_uuid_fk FOREIGN KEY (item_uuid) REFERENCES public.properties(uuid);
 l   ALTER TABLE ONLY zipper.tape_coil_required DROP CONSTRAINT tape_coil_required_item_uuid_properties_uuid_fk;
       zipper          postgres    false    319    5407    243            p           2606    306549 K   tape_coil_required tape_coil_required_nylon_stopper_uuid_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil_required
    ADD CONSTRAINT tape_coil_required_nylon_stopper_uuid_properties_uuid_fk FOREIGN KEY (nylon_stopper_uuid) REFERENCES public.properties(uuid);
 u   ALTER TABLE ONLY zipper.tape_coil_required DROP CONSTRAINT tape_coil_required_nylon_stopper_uuid_properties_uuid_fk;
       zipper          postgres    false    243    5407    319            q           2606    306554 K   tape_coil_required tape_coil_required_zipper_number_uuid_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil_required
    ADD CONSTRAINT tape_coil_required_zipper_number_uuid_properties_uuid_fk FOREIGN KEY (zipper_number_uuid) REFERENCES public.properties(uuid);
 u   ALTER TABLE ONLY zipper.tape_coil_required DROP CONSTRAINT tape_coil_required_zipper_number_uuid_properties_uuid_fk;
       zipper          postgres    false    243    319    5407            r           2606    306559 @   tape_coil_to_dyeing tape_coil_to_dyeing_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil_to_dyeing
    ADD CONSTRAINT tape_coil_to_dyeing_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 j   ALTER TABLE ONLY zipper.tape_coil_to_dyeing DROP CONSTRAINT tape_coil_to_dyeing_created_by_users_uuid_fk;
       zipper          postgres    false    5385    320    237            s           2606    306564 S   tape_coil_to_dyeing tape_coil_to_dyeing_order_description_uuid_order_description_uu    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil_to_dyeing
    ADD CONSTRAINT tape_coil_to_dyeing_order_description_uuid_order_description_uu FOREIGN KEY (order_description_uuid) REFERENCES zipper.order_description(uuid);
 }   ALTER TABLE ONLY zipper.tape_coil_to_dyeing DROP CONSTRAINT tape_coil_to_dyeing_order_description_uuid_order_description_uu;
       zipper          postgres    false    245    5411    320            t           2606    306569 H   tape_coil_to_dyeing tape_coil_to_dyeing_tape_coil_uuid_tape_coil_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil_to_dyeing
    ADD CONSTRAINT tape_coil_to_dyeing_tape_coil_uuid_tape_coil_uuid_fk FOREIGN KEY (tape_coil_uuid) REFERENCES zipper.tape_coil(uuid);
 r   ALTER TABLE ONLY zipper.tape_coil_to_dyeing DROP CONSTRAINT tape_coil_to_dyeing_tape_coil_uuid_tape_coil_uuid_fk;
       zipper          postgres    false    320    250    5419            �           2606    306574 9   tape_coil tape_coil_zipper_number_uuid_properties_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_coil
    ADD CONSTRAINT tape_coil_zipper_number_uuid_properties_uuid_fk FOREIGN KEY (zipper_number_uuid) REFERENCES public.properties(uuid);
 c   ALTER TABLE ONLY zipper.tape_coil DROP CONSTRAINT tape_coil_zipper_number_uuid_properties_uuid_fk;
       zipper          postgres    false    250    243    5407            u           2606    306579 .   tape_trx tape_to_coil_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_trx
    ADD CONSTRAINT tape_to_coil_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 X   ALTER TABLE ONLY zipper.tape_trx DROP CONSTRAINT tape_to_coil_created_by_users_uuid_fk;
       zipper          postgres    false    5385    321    237            v           2606    306584 6   tape_trx tape_to_coil_tape_coil_uuid_tape_coil_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_trx
    ADD CONSTRAINT tape_to_coil_tape_coil_uuid_tape_coil_uuid_fk FOREIGN KEY (tape_coil_uuid) REFERENCES zipper.tape_coil(uuid);
 `   ALTER TABLE ONLY zipper.tape_trx DROP CONSTRAINT tape_to_coil_tape_coil_uuid_tape_coil_uuid_fk;
       zipper          postgres    false    5419    250    321            w           2606    306589 *   tape_trx tape_trx_created_by_users_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_trx
    ADD CONSTRAINT tape_trx_created_by_users_uuid_fk FOREIGN KEY (created_by) REFERENCES hr.users(uuid);
 T   ALTER TABLE ONLY zipper.tape_trx DROP CONSTRAINT tape_trx_created_by_users_uuid_fk;
       zipper          postgres    false    5385    321    237            x           2606    306594 2   tape_trx tape_trx_tape_coil_uuid_tape_coil_uuid_fk    FK CONSTRAINT     �   ALTER TABLE ONLY zipper.tape_trx
    ADD CONSTRAINT tape_trx_tape_coil_uuid_tape_coil_uuid_fk FOREIGN KEY (tape_coil_uuid) REFERENCES zipper.tape_coil(uuid);
 \   ALTER TABLE ONLY zipper.tape_trx DROP CONSTRAINT tape_trx_tape_coil_uuid_tape_coil_uuid_fk;
       zipper          postgres    false    250    321    5419            f   b  x�]S�r�0=��C''��4�s�Ʃ3I�N3��LFa4�J���������.��]=��k�u;����,u&�@�q&�#L&a8�"ߙF�2���&q���]XDQ��e�p=�$Z� Z��]��]<�A2��GHV��\��Cp���+gIv�z�R�V�d]Rx�����^w�!#;�m
��B�B��f0�v�8�FMa[���-+K,jXSHOiE3`
tAAԔS��v�1%%�DD�o�'�;Y/L�à�)ȥ�쬡�T"7ܷ�3K"5#%*�����t#���������������=W�$�����Y�l��Qi;4����>����k¾ڻ�!Ҧ�2�PS�DD���"�l��	�)IFUa���@Y��-I�&jzb*�%�T4�H��=!֖9[�Js[���Y5'܇�*{��K�[�(�0�ȍO��s�6�wh�5
��l� K)PUEPd+
C$KtO����2IS���"����"kR�]X&�h���W�X*���م�ɿ+�m�ɷ�&�7��n$�;Ծd�]�a6������cn��Ͻ�y�����}��6����}w�b�(H^��m�x�����{o�^�/P�W
      h   >  x�}P�R�0}N��`p��%�[Ja�`��8��
��:�ߛ��Vt�lf�g7g���vf�������n������6��˺�#%�St�� (|��y
��ʨ0��C��[t�J@~���`�I��I����CeO�ݛ�r����*�h4P#Eq�ɜ+N�?V��Zs�9�T�K��C�2Ƴ]��k#��L��x��J��zId�2 F��,!: ���1e��j\�@���������S�ls����6\�,G����Я�&��9۟H������RZ]-L���E	�/��p����~A�+!ki�/䷦uǲ�O�΂=      j   �  x���ْ�H�������g:2��UDPQP��.�]Y�E|���zz�ʉ�n� "���y�N�s�&��n�N�q0�6__���|4e�R�c��4�Qj��K��0�s�Ir9m�Dv<
䰘D���Q��mmu��^2��> �D�mG���N}� <� ~�������U�;�	��1�7�C���9���b���!����W�F���.� qg�� i��Mv�xN��a��e�t�Lbe�q�¢�I�I�]�8@P�K�m�J|�/�d9�FЌ���jU��@<f��r��N��&�X�'��4G�o|�Ȼ������� ���A;�X��0X�K�ӣ>?��	0/*&Pa����X�>����Ϲy�n�·��U'�[V�hf�A���G~��C�籐�TO��|i�9+c��mL3�:4��89��S����r�n'�H�n툭$�<ǁo&���p��3�.줏j�ѹ��~�~F�#!G0o �AI.B�{�`G��FwB7*G���O�6}����+�O��c�N�Ȭ���N�=Yy�TJ�ڵs�VF��
Pf-���Ժ�����0��nL�#h�NL��y���OŤ���$y����wRYؖ�d�!/)i��\Uuf�odS-�c�0�VKU�WB��@��J�?y��\$7�&>ۼ�x��+���ܖ sGQf�e���k���7�;vh�$�� �v��e>����gQ�S�q��%�?�0�����G�!���=3R�˅�h,+�"�˓LQS�]��+
�/e�3=JP���;0���V<�lU9�2�[~[���+Ԋ�Ja�Db��j�2[�_��,��͋����b�eS��:��+ȫu�,����Qt������+��g��i�H���H���X6��5��Z~u���7�ѭ��������?#�s�gZ:��C�?%,maWOv��{ �^]����Ҍɣ��֐�j���kDIڼ�&�Z�
dE�+H�ҷ&M"��&�@.��h뤗W~�?�z4DⰜ-�0f�y,/�g*D}h���
�8�t�������\��#SvQwr�0C�ZRk�"֫Q⧟f�oV~�q{�[yůrvڝ6Ik� �O�S�T�p=�:��q e�\�U��a�N@:�e��D�C��u��AX�y��(��N� Oc����xƐ��} ������8���      k      x����ңʖ �k�)�t��F�{# �/�����=3���8Į���/+W�Lᣑ}�4�aˆ�$~--Z&�$�������Լ9t��	������ F��@����!�o��0����W��#Z� �BC���*Lr�D�Z#��� �m�`����|�U?{n���`T&o�l�"��!Y��'�*��h�P #������2Go�d���Ǫ��޵ɻ��z�ݚM��"w'1j,^ ���E���_V)� 8q��W����ӳ�>|� k��U�]3�/\ !�LX���	#A�	Yu�U%�6��q <C.E�R\g��-�F�{� ��:
���TGt����RW�K6����i+/� [���3�����2`���+(�M\!+S+cF@M�qqF����7����cF�1��P̣��-��o���	��1�
.�����5���vBF�vQ�Y��Nrri�������0�<����[13�P"�P�.�b�!�\���_B
�.�2B�q2q�C���J�a��E���5iغ�qU���~B!����S�_t�\V❼'H"󵸧h-��k��}Mb��*� zg>os��� A���y	��:T�:�-�=�I��05Q_�J�V�v~��3�G����oQd��N<ƍO��ҷ0Eg��q��wkn	Rfű�j�8Y����z����gU#�q|b@]�I�|�P�K1�k}�F�u�$�yF ��Ϡ2�ۑ�6������)E<r����*p���N�����]m0m�=�I���زڤ�M�����d�N�W�!o�mt�6�=J��e�=|�<K�1t���F���{YUC���^6�b�
���K�V�#o���u�nj�q����j�U��py��<�W������J��Nۊ�e��~jJ٘����,��~������d_f��%�Դ��*���|OoY	!?-/@��<��b�|�:�����S������D^A�g��K��#6��cW�_¤
\�P<�R�ude�E���G ��q�b��E�]�!���Q�s��|�m��,Ыm`$�i���/�J6/��)�|`Y@� ^+u}������TMH2x���6�-� UV���C��%-�%��	��b����5���O% Cqt�;�����!��gv��V�������>���ܧxCsݜ�Hr�u��h� @��|Y�'��o���u�W�j'�ע8�)R5�̀�M!�)Ѻ=��n���F1�s5���M���0����]� �hd�0%�^
j?S��I4^4u����@EN������w��j�8������	}&��d��|�)�y�%� *���+��y��4 ��� �#dZ�n���.`�Y&�[�11 ���W�<�Ύ־O�ƚL�5a�k����׋-E�01�ȶL��>��̤[2�O�P�o�����U"Y~;��F��7U����-�� �`O/n��(�{R��´���P�H�UE�%!ؕ8gʮ�N����ٽ�m�M�:��
�͹*F����A?T+��~����q�hg�Rmqg1������N�'U�(�:��r5��F
!�$�v�=4��0��K��E�OC���Y $`�r]�֭p�iu���ծ8Ɣq��#��$	a:$��;��ε��vX�C��#N�N	@�3�O�5E3ʐ��j1���� s�0��*] 󽫨�k�nw���<M�ֵ�g<0��J��՞�$�ֵ@�V~�f����s	֓�ƴ�ɟ���Gy)З�J�*,h'y{̠jOayJ:��Įj?��xi"/V T�0�א���.�K��<K��{�-�V>�,�C(+)W;:��)P�-m�P� T����bM�}����s�O.}������I��*��t����/_
.w�JkT�#l����_T�7'6M��5S��)e����l�uk��������	u��2 ��C��X�����KW��/��)G�2a*�|�f�NN�^q�%�qXg���Zp���P��O����qӱ�;6�LD��M��n�\=B�A~��o��������zd�w@%�׭�œtT=�?W����VQK�|�/ }4r��;��O��Cĕ��V׏6���f}%�ϲ�[S��U�
��KL5_��[�'c��iYO1����M��\���V��#����o��ڒ�&�Ջ�62���(�l��PP���U-�'Q5�#�����A��d U<3E��y˔�F.��]�ߋ|�=TZE�t��'6.�j!�-��'���P�cn�leK������%V�}1_�^��;��8w�.Ȳ#��`��'�����9���"G/�Ǉ:iV���U�F�ZC6�2�HE@-��l�S#^���X5���|��͈�P�i��4F�G�~Q�_ng��4Tپ4`��Z�	q�:�M�s�T��8D���X�7F���?>���w��t%ʌ������� ��w�9�,��?D��!�*-/m
K���	��f]�hx�k����m��L��!�3�8����h������?�]��u�h<g��O`_G��B����[8�C}��a^�����ݙ�xX&�F��!*�oo��4�9�$����<F��*��Y�힆�D��?�Z(ˬ�0�7v ô���j�����B��K�����xE�&�����M�=��U����E-g�����a�࿿��۽��d;B����`$��8?�;�iU��Zy�ܳ:��s�0i˦����"�h�d�9W횡�2QL�7K�'k���Lϻd&�n�g���O�3�Dm��#7�c]2���P7�s����0�K�I�ldP�9$��&#��L��QɊ|��񳄼�Kf�;�9>A�;70���0|:���*���KfhX��x��=�����L�>�6�cG�p�\D{K�2kU�t}0����g��I���|��|λ�����]�(`>����J�|�K��{	[#l��w�V���`d��ٰ�j����I����t0?N����F"%zi���L5n>O�䳀iߍ͌wOq���K�N�I�/�S���{��5o������;��'���N ��	�<�X�i�^2�7�[*O��{��|9k�\p�Hԙmm��`��P���9���q�}}��L��7Am�����ѩ����)��/a�����!��L��n`���n����sn�dn�1���:��`�t�=����Kf��c�v�S`���9b�W�,����	/���p;���G�M0�Ѫ�T�9ҿ���Gbr��w���2`f��Ҥ��쬣�k{1u�E��c"ҿ�m�;�x������kq�ёmi�� Q��2D?��8�� �3'��q������@�ӽ�W�~����P�7��G��x�)�d�&њ�h��F�������A��a���萨��xj�Yw>P$QB'%�B�4̜w�:�Q�� �����T�x���ڻ\��1�R���{�F�q�F�!�o�����wʥ�S�Fd4�����f=�����r�����-�G5}��9a�r�'O����泥V�_��EU���H)I$e�AU"Sݯ��M��Ѯ��DUQ�f���IYa�5�S{��M�T3R髬�W�!��U7�� V�
���j=W٫��h�YGr�0)� v]���qᶌ$�IW���MK��q<?�2X��K=�4���^��̟ڊ�m4���=�N�!�������9xl��.H�)#�� ;�s����1�\��j���:���klR�^y����j�~g_p賢����&�HY��5]e���|����^kd��;�/��~����g�(��/t5��~`�Dto�,0qy�'w�q�O�k�G�$��Z�hZ����
�6y�D�����x\M��cÂ>)wa�E"U���o�Lh������"�N�Jo�(V�$��!�l��Ch���s�� @mQ;vi�a���޺_+<}Y�޲����� ��� ��v)s#�_i��r���(�����i�tx�c�!���/�|}Ї�A���� 3  �U��&�kO�a�
]unV�_AVX55[U�ќ���jy�`�1!���.��}��{�����Cc�X�O3辜b&P�}����@(���@���3T6ƽӶ�%J-�hGJ'��S�W~Q5���t�3O��P_0�СY�2��o����#fIE�}rf~*�p���>�f�U��Y����!����2���i�K�8m���<���ʏ����տ7ͨn��:�3֞�=*qh!C/���C~+�DPeT�\��IC�����l���\&��I��Q@�U�HDa���ż�=��&.xU�#@�+��a^���a��*/��6���h�r$/R���kW��|0�Aj����]xf��@ğ��Q�_���_{�q����M��pk@ul�1�N�Q�m]©?g�'�����{���D`��k��;̥�b��U�����J�����za�&�f�A��?���ٰmos��e ��k���l�詣�36��Ts���}ʠZ$Ԓ�=i�֕�؛�^�u�m�X��j֐jU(����3��y�V����g��j?hX���?ߍD���o�M���"m��l�����ڧ^D¢�.i�6Dg����m�_����kU�P����#E��n�B�;��-4�[�3��})�J�d�b�=B��ߏ�K��U��1�7 ��J/)ޢM��9 ��Dk���%�P!��߃�G�&�$
O�!��-�'4�o� �����'B������jס;��}��������ё5�$m; �p�5o	S�Z�X �����}I/cz&�2,����$�p鳚t������Q��h@?検��}|z�:�Z��iNLF�-&���y&񭆣�����͔�����s���,���7�M(?#���Ϛ⌆�}�� @��a�ھ1����=�]@���`�ah��P�{�L��Q�j�^��Rʇ��EƈDo�	��3BaJ�� .�7R�ύ���߆�Nq�{S����6>]�������?��T/X����0�NU���]#4y!��W��d ^{Y��n(���2����p�w���}�k[���t�a��W�����8�,�ӛ!�
�)���6��V[�70T%Uj�g����k�j�Y����,������9#�-x�Ǹx-ҵ��*�a�WΓ �*0n0W�b�,_[��9xч�FLҩ� �g����I�y�S�����Py���MZ:���@;�v�"D�W6`b}mU9�]:���������氇T~�Ü�g_C��L«ԏ��o��1Y(�,2���(�
�큙�z���yH �1� �(�ې�ѵ���ؼ�B��@ݹ)u�
�o��{�r��h���d�q��PwN���CM�0�Z����$�K��ep���n�ooX�n���Z��E|�o5�>l歂%���{-�{��o޵HeC��_�������Zl��mJ��N��6���ST�@��$'D�O�y��&ʢ��rC��	u�a0R��N��~{��1w׊���M�⊖�� uvÅ���1�a�ZCY�-�q6���8 ڒo��>�a����>2=�3l%����S�J�M~q�����������      m      x������ � �      n      x������ � �      p   �   x����C0��s�{˿��n�Z����G���O?����~MXC�A����[D T�f.iY㺨i0�y"ԥ�ee���-W��Sf�萵^�_��[��q��=7�]��L���Ҳ��H��y̼�ٻ���S��;I�6�r�d.!�&���1�^X�      q      x������ � �      �      x�=�Y�$+E��ӆ ���a���QDd�uW��A���ˣ��h���3i#�u��]��{FU���:�d�Iǘ"5�{};���4o����Q�5����=�k��}n]M��T��i���ro�I�߷-���G���Z+����J9��;�Fr�g�e�;>t�<K�y����ٯv���N���S�IU���-��jc�me�H�-��<�qG֞[���>3�1t����k�S�a۟��j�]=��I��rژt�(�l�}�(&s�#��I��䑄�q��sʋ���+�ܤ���g8͟9���������-i��֤<w�T�G�7�r{�_�.�sz�=csn~�H\v�Z�q|�H�%�1��f�pX�o�=9�ue��߂�����'�)�����k�yf�99�Ugm�f���:GK.@�F����W�K�����(�Z��k,`v��sM�N���KJ�N�]�j-�]3�*+GA�Ɂ��Jz��ɶ�Mz궝�� IHϣ=�W)�pN%�������U��r��
]��8�i|e�Rҡ� C�]6�XϪ�l9]����э|j�WQ�k}%?��$�L_���mz 8���S[�^�[i[����h�����K*����)�j�i�5JZ�Y�*��Is���7�AW��Ӷج���z���[j�>�'�A�V�T{Ϣ@�#ͥ��c�/a�z�`C�ҡ7��v]�4�5ևC���p�s��7�ơie��;9��)��:6[,e,p��W�G��J{X����2eKզO��q͌^�+ϼX�pO:� ω���,m~+��X��&&1Qhc��`���Ƨ��&0�l�$?��f�/;�*�߮]:E������f�s@��~�wU(�w�eӿU�zu��S:����[c�S�_�'C>�6f0�T���=�^��r:?�AȜ��Ӛ��v�)��U����]X�������^>�
�)w%9���ڌ�ة4��N>+�4���0�7�����!�|��.>��Id�}P� 2
���|f�)ֹ��κ9�7燅,�;�.@�v���1��N��f����L�W�3����oET����Y�L���lb��P���ޗ�\�$��&
�x[����z�x�U�Ϯ�cyV:SU�ޅ�ѐ!�青�b&9 ��v��8��hwf_�H��vLaffX�X΂15/[�b��x�]��̠m�61�mt�z�T�FK���0͓�>����V�%�';c�	�[kE����Ӻ'}��u5zl�P��Y�\��9C�􅢏��>TCe���vj��o�hj�*�ҍ]�gCۆ0*��ŉO�7�s04�fj@a�۹����,7Tv�o�S�s��O��k#,�Tx��_�E�v[�8��|,���y_�� �L����`g����Nk#NL����	����y6@��:�GF�0Xw��δ
����*f�)�o)�H�9�{�D,�Z�;xLn�ԥ�8t�v�W-�>6��.酌T�(~+v!-��/�WJ�K3$��@�6�����Z�u�m�*�T��^U�b�SOM튕��@u�E��L���ˌ�I�{B�9]�X�b�wV鯖g�\�����ٱՌda;S�7��z�"O�fH0�	9�L�lP������&ZP$ߒap�y��T9���6�Y�ű0]�_>��@��*j�f��=!1�a������X@>˖5��%��tts�9�р��*d,N���`K @�����B�Sj��8�,,.��ù�Qg;��_E~=�A�1L��ɛkWǔ-�ƌ���5"��`_pc��NG�oEK4��U�J9?RzbƌC��\2���\�x���͸T��F�ϼ&>k�oI��0k�՛,ιB���Nf�ߨU0AX��j���)�y��V�8�́�E�D���r<g��u�\wT���rQ�����:�~bj�V�h�׷��G ��ҋuoq�~�	��
ɳ���U무�b�	D����b7�)��~�/�g����1N�5�W��l10�@t.�#zl� ���-����<>!�8��!��D�Z��D� �k���A��~g�����q����J���g��o��ZE�x� ��
�$#�`gj�n�I���s��"�Q���d4�H"���MH	�y^��pY�]]8�3��c�q=��U�&�Ş��c |���`2��G�`�2$(T2��/ |��T����'T�-�AX>�΍A`x$���|RK�>#�bJ7�c1}��U��G�C�q������B�Zk39Z߸d�g� ��:P&�W� Jz�V�:#%�e`;j�\Rp�� �OZXFjg��w�/�>����v������sǊ|.PYP��|�=F_w
���^~N��EB�p������'	�G�%��{0|4$%:�� OfD�,�6Y��L�D/I�N�W<�����T�gF.e���݀�O��(L�>�(��m��C�/�/�z,�^"�Wd��Zx�.��^��pl�7�F�^X��>q��Ø7�3��1��ZX��DF<VU`7}c)��U1��L��i!�rJ���S���"��*"��H{+33�!�����@ ��y!'�\Ά�����<	�贆G:�),d�Pv��\�Y>j; e�ۘ_�%݁��lz`����ȡ���p˷"�	�5W�2����z�J�C����,za��!�'"O��>)Ps�~��c�9mwv��D���e�`O���dw��)�!�N����U��h����f&*��GIdWL'L��u�u�NH�3v���F�"������]��_��<|]ɑx�zl�bä{Cn`i@]�����(����6i}N�VDP '��x|:��+�D�D�K�L9�k!;���p�t�}|���A�T�`I��b2&�%��ҽ�����J	���-�b�R!�el͘�=���r�-�2W���^��f8nr:��4�
 �����ޤ��E@5Slk�e
�@��8���I�͂���`�q��C���.'�M�q7GÉx�����6�{[XT29<��f�й^�6�i"_�~)��K,z���d9��Y�HH<CX^b]B��d]�V,�iY��͌k^U ������t�e��}+vC�S�o��ZG��sNl��Z@�HLb!���4�(�?�� ��x��_E��:S�Y�x�T���&iJMX�C^�EĦ`aJq<`�[ĉ������`��� /A�uK�Lpr#�B�i�7hK��c=l>���'3�?ʔ�*ƍ��k��^HCQ`�����s��1��J��� E�+�]� �_����K�1���R6�pX�I��0�
$u\��QӚ<r��`��۵�������$�d`F
��߂��m�jĻ���LD���)��1�~��0e%Se�����i�d
G[C��9�ⶐ�ʶ���.7����5v�4nO_�Ö́%�߅�P���w�v��]�$Z�,��
{p�Ѣ{��7�ѐ.���0����+2�8��C�S$���$|���+.+�Uę��=!K���4��|"1m�ہ�lA024�%.�Z��5|�w���v|��'.�g�D�`|�~�<��ܡ3��U��Ew;$�u�?8���-�!q2��'�!�AT�N �`� PҖ����w�a:&�6��}og���]�o�w��$����o��"[�Jp1,͌�2ס-y�EF��<ӘT� �~1B�y��р�9�dvb����i�ρ��Sq�6�覿�!°YGg@A��|�a��rG'�G�l=�Z�@	S�#�'���,����d��}�>��4�� �b��@�j��g�k��ncF�D���gs܍�_��8;�i/�������f�O�$v�����򅁃j'!��)�����{v]�j��
��\�)�l�|<T���y��00��t9�OJ��b��oom���ɟ[cf�'>T@)f��=+�k!J$�x���=����d,�T��lEO#p5��e�%ˋ�3(-�q�W���a*���?~���ؼ.�D�V<�I$�]Cș�gP0��<8Cf.{<Z�X����4G�W�XZz=?�Q��p��&���� �	  �$��x` �0��+P���.�JC^j��n��,��(w����L����K0[0�"n=1�e*��%B��͌���d.�z���5��+Rf�_BAdŸ�C�8�%������U�HpJW�c���� �m�}BQ��4�ؠ���Dz�{ʉN�
r�	wM�Vĩƥ=}l�29����;��3��3s��4��!ZVb�����3����=�Xơ3wC�
~��1�$�J6b	�p�̳qJ���pޯb<kq20.�j�oT�kg	,��#��0b�ss`��"Jɏ)"�aH���q���
��	�ɞ"�|����	y��BJds��.`�OE�����+��b�?��)	���\-�f@>�6���OY���[_��#�p48����-�Ʊ8]�1ά�ǺB��o�a�ЍKx��X��'|�e�N�A�h��糖���49�z@2�W&��?X��N���;�O��I�$���Y
%������q��ec�&��i�+�!�I��q���%I>d�d��
�Gq�>�s�\O\t�_��t\2gÙS���O�g|�+�q��@�|�,��<Jʏ�L4[<� �`�z<F��n�xW�-�'^ ��A���b҂c��)%�j�����\~����D�tar�Y*-E֠Lb��G��J�{� �gX�(���xA%��\N�\��!�|�ٍ��W}���\���$Y��(I,��3�`&��=xC��qӅ���ҧ<� �H���e~G��|E�����P�wk��&�y��1�8k@������$82�}fap#[��K\���!y8�#^H ��Hu%�sa�:���8�����W��,L%q�F���x�I,���*.��Y��:�e$�E�˿3NI�1��̏mG�6%.��
�I@��W����
U�|p"2��Q[��
k�mܑJ�����}v�*�Uo���(9����OA5F�
 �6]��8��Kq��V �s�^C��?��C
ɸw�h�������D����m�WF�!JI�1��FͰ��Өt+2��)��j�/����3�<q�W~����-N<�c���#�f�JO{���n�p'�޶�7����|uLB���Ԧ%�Ǟ���!Q�kaw�D	�٘������-�ʪ�$v�%�ҒT " ����O+z3�/^6�a�9.>|@�����*}�G �d�)��d���Bc�� ��(7��*�"�4���%�u-:�f��o|��x�|�"�D�����>q��qb��d�P�f�]r9�$A����A��;F�r�Y��n%k�?��Y 7���#������k�xz��0�%h5dig'lNC���fdJ�DZPpXb?>�xR�,�Bq����/s�k]�|E�Q�p:���[�m�\'q�FI}�0#�������A%�V��ۉPO|8v�� ���ASx��(�ڝ� 2&	��k�X)�	���������P�\�Q�/Z�^���=J�'���(l�sǧ	�'�
�G��z<���,���|[��i�R���zƶ]�ə��Aǅ'����G5��CLxée�n!g`gd���E"%�>JړN<4�aI�I_�3�b�'�^p�a}2a5.����ZQ<�����S�F�o)�O�7���;�B�$${Bj����x(������`��[2�S�%�)q��s؈�	���<L��3@)���]��ǳ��03_\�r�:^E#�?Ǚ�ͨ}L+C�����znPΫ��`Ÿ�	G���o��	���m�M�+8�e���lc{�uvI���.����ᐒ����R��u��O��$.�S��$��5B��zx<�'��oL�H�|�G�^��J�����P}�L)˚q���[��p���=��V⭄)>�B�yY��Pr��b�/%���X���c��)<0/��~�~*9�ۀ���e2�%;��}�-|T<B\�S��3B���PnA����n�H�i�y�����C����DX��9���頲��F�@��$wQ��E��`�NB��:���T�;�WR���@�=5�6J<�����K��,�<��0�F��o^U�"�W/��8��K����DQ��:�ڭ�����z�;vag\�ų���d|I��u⒄�8d,J�1q�II�r��Sjf��L#o<����5���Ct��T�a��;������E�7,o���yA�������a+M�<M�`��8-���M���?�x�8�S$�j	R�$���:p9���m�6���+~�
�?�ѝ<�I��񐴨�|R2?�Tj�ha1Z$ �e�bK��v��$+��q�!��wFQ?%1��<Q�����J^��K���C�"�<��1a4��F#ˑ�>��e0�/���Y���=��Li�����t�q��eLG�+�$��/&������m��,�x�OܬчgM	>�!��Z!����Q
S�G����q�,�SgI4����{��?旈e      �   e  x���Ks�@F���`9Yd����	�`�7�+��ڑ�4��&�1���*V�9�{?���ơ���d-�sP2Q�r�[(KH!�F��G���K�t��0]ٌU�����X	�Q���L�O�<؉ �}�FPB:A�`x������.}�o}��Y���XB*Q5��#�JV0��;U� g4�d�&A��m"wN��-_�����Fv�-`fI���ZR)�����׹+0�/״���$~	荨��6.��%������b73�`]���CV^7��I'�x�̆#��FU�����o�O'J�������o���+���;ᴿ81�Xq)�j'!s\<̠u��ĩ���k�.��1ֻG�Ʃ���rj ��|Ǌ�ZQ�1J+Åi荩y8�`4:���6c�����w]o7|�ԓ �Yz�ۇ��-�x�l�Q���ze���J2k�d����|,a��Y������ZeE�SZ�Q%����M�7�И	��FҐkV�wz~T�����- �"�u�꽙b=콹��J�U�ڗ~x~s������~�"�k�
tgHhG��#ʛsף�z��(����(�|�������b��{j�?[��o�3      �   i  x���Kw�H����`5��4�c�4>����ot*`x��~%�$&3s��U]o�*�B�c}��d@q� "�J�cX^�D���S�u`A/��q
%���f��F�� "$ygYȰ��B��nl�*�j�QguX��S;��τ����!�����>si_-Ǯ7^�ŧ爿�C��n�d����ՙA�|V��h'��Y^9>@�a	r��q�ϛ���|O+��i��|��D��5P�9�k�� x)���f&�����p!� �|+ ��t׍ԑ�v�j�����B��]Tt��J'��憎X�p�'�� |�P����{��������w7=�)���ۗ�"6�FT?O�)�)�IA�1$Q��RNf��R�"��W~B�pw:�6)��X���{�`{�<;���;^^I���+W,N;]{�i`&z3��#[��S�W��b�>ߔ�'��Q;�nǑYJԏS:�`�ؗ��������	P��n�Pj�'n�_�Zc�ۆsH�e���),(_�ڼf���x>̤H�V�{,{`Dl���]������F7#�������L��ev���g����9��pY�#���]��6$t������a}P�=ɂ�����P�FUj���և�)@q�8�����iU|���7�kn�-a��z�<,�u�?7����I���m��;+obu���X^��h��%�&�K��R�Y�a�6��)��A�\����?P�>�g��h��eq�S�r��վx|��4,׻���s84�K�ܔ����w[���|1l���Q]�<��΂8J����d�
3�F3�%S��e�g|o�����s,d��S��k�~� u��S��?��N�o4�      �      x������ � �      r      x��]i��L��L�
��h5#���>�i�������\氍G��\�*_T�����~�Z�&!23"###��|6j�����(H����<�)u"[�KU3�J���p�0r���������������vۑP�m$G#�l=�T�����R�}r2���&6�Q}��=���BYc���� Q�B ���'� ���8+�*X�1  Sg�ŴY��5-�&sQ�5Pl��%� =�\��)�D�_i~r�H�����hXV�ţ6�]���-e�	�1�C��z ���4��FiHmD�㭁`�t'ө`0(^#��8B*r�T��[U�8R��|Xk��GUW5��^�%8��`F������խ��M6v'6Ʌc]j��eiˤ7�Dp���)˖m��f�@�53���a���F۾ަ���,�%��̕��Jr��	��ep;j-[�Xd���.�Ym��l0_���
�Qk�w�Mu�w#��;`��:�D�,����`�5'qsXX��ڎ����灞kH���%ڒ"U5@:�'�#-��R;��ΖF�����~���Z��\M��N�Ju=��x��	�(XbN���U���ؐ�j���ő2��/"��| ���ٱT�WF��@�^dfi6<هx�+�ID�\j�⣇-/<�^� ��j13إ� J�uddN�`�N�㗜����	Q��07u������.~2�X�`��L��f=t���撣�pRS7c���۪��u����%�����C�_�de�1������+�������$�����W5��Q�Bɴ���
�?����?��<��Z�,���2����ٲ���f'��oz��:ɍ�p���e=׍>��ye��{i�&I������<�TN�4'��{�� y<��Ei:7��O|�Ob��Fh:zN2�WeS� o�I	ݼB�$?�K⻞懦v�6&t���{<�P*�<�|R��FN�hi�o;��� ϥp7�M���;�6}��#����+�h�)GS�T&>T =�%m$�4UzS�-�Ύ����8�B\���SZ��#D_S4s�=�F�u]�w���X��˟J�
~*i���́��ɒ����2e_J���(H��'���&<ǯ��7u|�@)"NP�$��N\8�%���  �z�f�yt7�C�[�70�=F���虀����ry�-4�L���fee�rz��0pM�S`�M�h"�^������0lt�l��.O��.O���.�_�%�	�E� ����R'$*�yT�4� ���7�)n���#��*@�jdY�Q��R�M�m��ncWB'���>.6!<�zMnū���ZN����9����\;2�z���t%��c�kXR�oB�C�L��� ��%kcqZ�5FS1)�6��*��u���.��T��/w2X��ݠΌ��a����c�)?4{����ޘ��6S.�ӾlZ�bN��l��-WF;\��XIC8�]h��l�k����~ ��}���bo�vV�t
��H%��&��~ω�`4烆�˽��Ԗ�F��5\��Y82�#�qd,I~TM��ѷ��#ٯ�5V���1�g4�4�e>�;��d_͟W!i������c̝�~��c������'�l�P1ޖ��3��Q˽k�e���Ł"��'+�R�T�ky��5Ô�f��l�����/�L��0r�~I�*�����'��u�/��5�f�}� �Su�&O瓫�l<W�G���s��+y�7��9�"���p;������]���-��Q�%�I�缑�Wk�ukO%�I�H�w{�G�����#�QC� �z�tz7�{ZvM�f�����������띫�{}�����N2"��5�����3�`�_Q�z1�&�i�^���n��J^z���'��
�{.3���~��l*�_v�(���.������󛧔7�tJ{���Կ�����e���<��s���h�����P΋2�7�����c�VEo��Q��l����5��C�	s ��|��ы��sW�.Dx����G��7&v*�=?-�1�-eOج��i`~�$>��]�r=�/�_��;�8Ҿ(��>�~R齳����C>�k�-�{��l���������N��F�q��8��#�3�7ع�?�����q�m������s�����A�q5��p�3m2Z�/��Fi���O�e�f�-���݆[�i����g�cF�߽3;���f�[��y^`vC?e��'�ǭu�ϒ��{�~]����u;���7fp`%Դ�x�]K�#��ԟ,�ۍ���ί�ה?H�_M�����G��&�'��f_C|9��ŵ\��r~����~i�kH��{�g�Ꮡ��ہe>%�<'�d<ܱ�z!6��M�G�hϥ���D�?H�s�V���oV����`M�⾯D�i�n*�c���9��J>'��#��-[�f����/�|D�^��i���檡C�.��h��W����#k��NqH�m:O)�y^�_1>_�Z���^2d�dv�r'�Z:���\��&V&�R�e��i6��̾{���*��SV3H������%�:���A%��H�ne5�\gs��`��4���ToI�)�j��U�ȏ#��H�TW�R���j�Dv�6�K+{��.�[&��D��M�ZTӵ0���l]�2�w�w�x�D=?��CT���չa�o�i�A����)Ѳ�:�-Y@����T$��ڡAw�Ds�vp^4MlϊЮ�ѐH(c����q����kuz���l�\N}����v��R��m\֧<�'F֬r�a��!m���r�@J4XH~��:�%���u;�'mW���Q��0hz;�K���|��y�	���5s�@d��xH���[��4T�U]2�/�����D�h���H@�\e0T�YM�5��2"<��=�ki��7�&�J�c'idY����c�~���d0� 8� �-%�#����3kO �;�����"=,WY�=,����=ع�-$u��0,��*:�����jY�GR�av�D�iy!R�t�\�����!��sV�QGBG@K�M��&RH��Lܴ(��A�|Q!�%8��1ڬ��l�Z�
���s�J���r�G�G5 +��$�`7 _n#q$����6Gl'��58�m�Rp�@)Gr��Ά0��GY��z�G���\�ˋ&�1g���en�7aК� Z��^m#���l��L�g�c�����00��	�U���2�|�bIU�9C'k '�΄)�)<��i� �=��P(w��ZWf�!҇��*��]r"�K�	 � %�6W )HDo�ٚD�k��@;R����q@:\d���btB�˻���Φ�l�m%%B�<e�߁7|��U��q-3'+���+Vn[��S�5���>/��dڑ]j�d��"���V+q�.�����mJ4���H]pÖ�@Tw2{MܸۥÕYF��
R���(�-V�4��2D���C�)�D2K�ad���=ʷ/X=h��;ְ_F��$�1;]bKp�nt:4��N��@XA0�`'.�-�^	LT��Č]�4չ[ /ە�ngm?�+��}^gf���Ę�x6Rr���v�1C��þ� {l/�Q��	��2����g���*��g���f qm�A2=�u��I�!5׸5��hZGk�g:�SD�l�R��0\���?v��� ��9'����`�>';�I�a�ۻ?P�ͪ�{��u� �v9qn�Fd'�8��}uR(��P��Zc�L��K3��Zn:�`�V��^&9iٙ��ZK�I���}rK.mTm���Κ]��Wr�$a�
�*����V���� ���� ��0@})�4:�7G0+'-ʚK���A���׆�X�c�=��ӐA7��j����~��ݡ�A������zනx�p]��2�A{��X�tBjj�tdh9*�����k���I��FcK�,�ܤW����id�(�]����Q-B���d��r-�6�)�G��m��:���q����Ux���a�WL
"�	��N���K*dc�Mª0�w12�G��}�[��!���&�`_�b��. �  &��0����]���7��I�1�j�t�0���H���O���j0�W��1�=����X)�$q�Z,#�6�}co���x��� ����� )�ԞηCU7��%S��]��o�7��?�{
�e'F��!ny����\[� .^����nGuwq���^h'�;�b���=gp`Z*��r�3�z��9:����p��T:3ɣ��`=��8Z�㝶�E}"�ז��J�B�j����\��\�K��v�w�/ȺE,�;@�	I��f��@���l�����!'�&&�� n�����&�ަ��W��X�Dei���j�t���E��C\�!�=��'*_O�@�=��V�i�I�zn�������;��`�1�ngonx���}X��U��d�2e�n�$ڵ�q��ze�N��Z���U��q��Q:Q����)�3Y2�S��\lw�㲔x�Iu���p�Uǧ�޴MƵ:*���ը�=�H��{�N�GYJ�m�~we,5�#�1	hH���x���w1�%3������je�F(���b+�ɓZ$�D4����Vz�e��&9jwع�QM�UE������S�q�5�ߛ�ɚ�f��I��E���h�38���4����)C��e��6�Ѡ6'�kаɹ� ��=?m�Yk��8���v�h;_WcF$� �E�����8s��Ǥ1��]����D�]MR5?����I�u(�`a����e��%Αу֮�������#�>Ԏ$�����=ca���NX"Fe���cK�%��|��Ӕ(47ڑ��:kC���5�Y�MT���fWc������-�{�M;۾�G���`;����u*��M�ӭ�e�+��/!�oz�$2�k�`f�f�_<t������1�2��4eL��Eq�6�C�k�p�=d�J�k���<�7(NT�OT��"�8x]�.��~�u����@4ٚPgex��[����eg���]mLb����G§�,�{y�0-}�e��"rV���"��EM�n8���Hs�mw
�Ǡ��O
����)\���)\���)\����>ׇ�0�r}�����A�[������0�9g�p�4�B���ׇ�u��}�M�"�PV��F�- �!Yg��5���a���j9Z�z&�O���O���O���O��|��a�@ N\�>0�~���s~��a�&��e����Ж� ��Ͽt;Q���#����~��8d�����ڠ��N��'�}����l�lU�ݔ���T��Bd.�_��)P�T�7�����.����q��������W �.�ߧ(�On"~��hO&�?n�� ��e������=�oT�C���{�᳀��d1sN�|��c�ɠ��{M����X�/O�f�],�w���9���W�c���;���k��P�gs��.���P�?[�p�唳��$E-��sD�
(�
���K��~5������.0m?��a �p�P$�3X[���/�o�e0@@z���mw�.՝�����8a�	��^�{�������I�2��{��oXOFF�nE"1�"�!`oȡ~yOD-x� #�ɠ:��B���60K��`C�z���ho(��W�!Հ��[����h�\#0�>�d�^��^��ϛ�mc�v=�6��<��Ss-0k�7���/�w�򟻿��2����*}V��n4�O&Y����f��?�q�{��Aɗ�ُ���3�=+=��_$��;������x�H(E��p�P�^16!�)0*�(#�\�qa����V�<���n�C��q&�$���w���])��Bw�u���^C@�8���Ͷ�d�PsߞL�[�����>؀�n�z�ðn.��I��8�UdX�#)2��X��X�?��Y�E�l�%��γ��j��*����r�^R��OSB/Hd�k��'�����}���d�CM��Tj"�&�kd�X��� ���֮�^���~0�" ��|s *�x�`%.��

�:�i؈3���-�[~AyJ��Y���#�'�����è�1`��L�މg�� z���!��L��?���Q�>~0�}o����g�2"x7����Q�g�%/Q�����> �_�h���}v��G���Ѷ������3����sO�)�ޱ,�4Gj{-�O[u�YņoӦ�����A��0 �A�7��ƛ9뷃��u٭h��ҬhW�O��\����l����>LGd�G�Z�{s����������I��8_��]�S��oF�N������;##�w��]�ϟ�}C�Q���,�2$��N�Ɖ��$ֳ~Qm*n}��	;��wA����Ka��O������(���C/jnva�ۛ֘�&���<t<i�6�Ry7��k���>�n����>���1����=�"�{7�E7,�E������ϖ_S}t�}�I�r��( n5Q@���!� �@��U�d���q�֑�k�a�������*����������c 5繓�\/��#+4��<^�1��Sҷ����l���=l�;_����G��7)<����.�1.Li�Q@c�"/�1~��h���)g��I�Z@c���4�w)Η��8׾;�|�����R��ES`y��X��T'H
�@;�
U �.Ap%*���� �y�����k�?KD���
�=�`��?��� ��Q��M����Mf����kY����ő�"+��J-�R����d��Zd�Y�EV���wI��~��	��R��u$ݛ]�R~���_��%m��P���/�8���y(R��T�wi�T��S����ˮJ^:���'��
^^5i�}����$�{�\~�,���|�뢷�*�+x�M���L����	؇�=οJ��G̏��?%���T�������ˋ��S��A�.0���8�|��"�H�.ҠU�i�?[�Et��唳H��$E-ҠsD��4�"�{��Me|w��v�t����y�94gnu�,�l����(���?;}����j�Sf9F�i9r 6��r���Ͳ��/3�[�DX=s�u{�n��5 �����6���-�[0ډ���j��2g�b�U:�}H���R�0|�'Q���{����L1?[�?��擗��Ex���COaIl
��+�?��h�0Y9AU-C��*�l
�Jw{}T�B�7	!�1¨0oGM�h�D��UlU�$;󓭊��䇮m�Svl��ڔDԈ�:�W�V�.�W��%�mO��]�����d:�kd�eU��G��(�����~��aa (	�B_���g4`�?~!&n��̮�	�o��m�"cH�س���XR?���&@��<b���f��a��"������s�K�c.�U����Q�F=FN ���b'+���=��P�u,��s�>�Sdwٝ�P�EI��Y�qi�Eg��Y�q��4��4�gw��/��u|��u�O�$HD�gO�����x�Ͼ�KUP��<�X[׃��J�y4��?�o߾����      �   i  x����v�J@��W8|o���E`F'��h 5+[�@T��_H��]��az`�}�NS����^�X��q�0��>�OB^;��I�;�pL�p0�?"���:�"D��$4\ہ�^�&��v�j�A��*�����L�B���Q:�筰��?�P^���y���l�XA�X�x�5�%�>Ι�rĐ��	.��c�M���y,4��ű�&���e�\�J{��DHE���zw�5�KN��4̚�+��Ȝ��d⷟%2���֓T�����!�y�{'��>͠�Z� AБ�Q�$<����}� yE'/k�}Z�0�TK�ḯ��TU�%��V0��r{���*PQ����7pQgO��1@ȶ�U�INdLD����� g���V��Uł��=�pn��VE�"ak(�j6���+w�%PXE 00L��i��w4�:r��!��(����6uí�}m�����;wEiq��&[E;4�_�p�w$7|پ�TP�莊�Su��I2a2��m����w��3���J���u�������Q����Z�T6ku�M�{U-� �XpY��p'���vX��� q׆���W�m�\�vF�gp;S{�O����(�q��)U6�j��場\��a��nz6�U9\$\+Q��o�?��QG�W�`a�.	�������-�C�����4�#j�3~�PU�H$\	�A�yn�w�kL����r��s���h��3Y5�l�F
�7�X��sE�&F����rЌh�
��x�е
0�h��N�1j����ʺ�/E֋'-ߩB�}½�88�Xs.�`�����Ext��̲-)��M�,_B���n�E�e`��J*d�CY���b�W��_�V���h      �   �  x��X˖�:�|E���B�{��OZA�u'>P��_Cw��^2ݫ�Je׮]q�j���S�]�u��k��t�ə5šf�@��o������tq�̒k'[ �����?����2�d�P5V�Y H���6�7���@:W�Lb�hYϐ�S툉�ט�� [y�|8E#�(�og�>�I.o�`��K<(#�|��I2"x���o��D�]8�w�����{&^d=i�w�,;@�A�kbs���Z�+_�7��׀�T۷{2ؕ�����}S^B
2D2�Q5�e�!/�x`L�}�xY��4�L�Yu��� ����o�KPQF��y�����}+�O_:�ȵ ��RC�� .���&���!Z��%�� (o��Nr��33.Yhn ���L��a�ۻQ�Tц�Xa�L�0+��U�^1/~��q� �Q�-F���9@խ
�eH �)�,iiK�ހ���fՕ�� ���Ѻ(�j+����zu��sE�x<0�������]r��l��̲t�ò�	�܇Gap<��#�ΫLM��:��帷���q2 K�2y���"��ix�V��㹂�PՎƥ4�2q̙��YN��d�]#��j*;��ܠ��%F�[��M홬j�f	&���]r��]Ff�G�;c3�@�U}�t��4c|��'�1Q�Y��5�]�J���ӶX��ܲ�R�ku�a�w�5���2|�����"���q�3�_.$����Ӟ��L��3�YbB=�̧S�d��&3�y�__�ȸ "���V�ϥ~�>�����f�?XB̛���lP��=H6�E�`(ڦj�t�ֱmrpN������[�ݧ�pbp�4B�1~Z˼�3�7�\�	�蹖_!~��t�>�ۡ���=d����?�/7i�Q��X�dfk��M1���+ͩ7�dM�Ө�P���0�.z� .E6y�lH��^��� �� $^�����x1��U����&�����P*Ž�c��-&�r�p��Ҝ�po������D�]H���3Ud�}�Rf���m�Q�<X��?S1 ؂���z$�!e�'C�|�l��B	����4��9��(�RH�މ4�g�8��K�ن���{?�Q�
�Lw�t̏{�u�9ߚIb\��5	de����-m���)�ٸ�v���y5��)kk�S���n��ʜ��~�G�!_�9���8����OJU����x|�R:��U?��C56��B2���N�%�1��	��;�F�b>EzoO ����I:ȶr�umX���6�ɑ��Q{y����&��>*�]Sk�l���R�=7�N��dH�Ŋ(��l���Y��B�il����'3O������܅hhnh� �Ϸ��7k�&��[S���x~�M�G�a���?���y���f'�@Y��'�(Ͻ�ib
�~|��^O<�7���_������Z��mvp����{��$�"O�[sK�j�f|���@��¯�e%�����&�5m�|�O˟k��SNOƖ�s-?� �B���q��kSTM�Y�T�j_��L:���`π��1�{a�w!D�8�5�C���*��\��ii9A�k�8�{>��1x���?���>����A�I	�&����MշB�'��- �������^� i4�Df9R`����ׯ_��
��      �   S	  x���ɲ����짨����P�NTP j��
�I�<�u�SuH+��F8b��j��dj�0�{֊G���J ׇZ���8��(B���(P@���b���`��L��{׳|��Z'\��Bݨ��dZ2������M�w����%I�ǐ��I\~��o�I{I�}X������G�+��� sU��R�a�h>�ShH�ZM4�V/w�e�{��ߵm[��~����w*����}&�K[d�6����A�(�wQ�{�+�U@e��y�eV}����?Pj�@��>yNQ�˩��8��0F�Ov�ů�¨�Q�֝��2{�."S��yEu�6s!���V(����7vE��Ů�k^���=f�W�Z��AxZ M	V(?`�J&]���/��-��a�Ƀ�d��je�iC(�i<`�W�F5��ܗd)�����H*���]�h��%݀���7�0��z�	a�$|�"jn��[�L����<rEP�N���:4�ҧ}��K�W�\�He2��Y�i�t�q,�He�g�v�;��ʓ�%_�ϓ]sу��-�W�<�����f�~}c��Я�� U.� ��9O�*�H��l��f����~��B��U�_���������|���[�~�4�y�\���3o�q�Vv"u �-�G1��oX+Ρ���2�Ꮄ���3^y��d�o��_��O��}��Z�w\X�o�R/?y����	ݗO���i�=��7����L����+^o�t���/�pi���e>~��=b}��F�E��ڷ��'o���Y�'C>X��q���h���u�#�A4ƒ�V�1���F/8���#'
ey�e&s#���0�3�ys���Ո&�B�7z�,y�7r����y?%�K�8�S���U�-7�=K�9:cI��_���X0�
s���x�p4��md�y����K'#���#�ƃ��'o��3��aPT�^��߳��W,��N��o�����7�SU�8�S ��/A����Gf�؁�0B���@f�����d��醙��p�K@�Y��'B��x0�����Ǡ��+�L��7dϳZ�5��Y��)��������E���-aӓx��W���H����7�qf���W�!(HlW`ۄ�9[��>�%�9�Y$�_�"�x����N�Vt��lwz�3T�a��p���щ�Z��;�_+�ɚ*��H'��$����G0��ئ�	�k��[��"��F��h�޺a�4�/�" �7��P%�!�Gը����WZ���A���6X��wo$�H��8l[,�=$צ�:���~���((���#Ñ�FQ9�ёKA���T^�XxAA���(��Q5ͤ�h2Dd�|�xM�����%���z����n!�"�uug����'����/	�I�	�Ex1��w�T���@���q輤?�g���hxp�y1)}�����3��"�g��4���o�<~���&��T�㭰�%[�ǯ��}�IV�[�UވM�l��J���*����G����sb�虌�g�Ö��+oQo����wl�c燜!wf�3�ĺ���_bEPPI�W�q g��#�&|I&�1���T_<���<#ʥȣ�A�y7�&�L���EqΡ���܇ �G;{�K�N�9g�� ��4�䈯+Ҿ�����/�o�زO%9	&�`<�[�|~��_m�����n�q�GEN��))!:�������?ea�wR�����Gv��(�S������8��6�A��Y=���؇~���{�����R~o��L :IX����=~8�����2�e�ɻyK�>~���h�.{u#�B�H_*�tȭ��K|�]�~�����7�9F5��$�`���[��!J����;m
�~<�&����}=y�w���|:�����E��x0�~�������Q���L}�>01&�����?@��x8��rͰ�?�v��k���(���w��}���I=E�!q=�������|GU�`��������cV�ȚB�P�ƃ���y�z"�n��%�Q�E���~������|������.FH�0%�5��4���5���J	�ףj�|�bN���0��I�7�\�x�oBǣBa����{߳SY�����F!E�Fr�"'bvZ��o��^���]�:�F6�77_旼�{Ӝ7�﷎gՏ�{��_z�}����y��:m��?I��+��s-
c���bl�{���`��\��2 ]�N�g�v�G���,�����T4^�tH(�0>Z�ps��{t��}��Ͼ���a���蝸��f͵>7� ���k��O�C�]G�u�҄�%C�{o4G��v���}||�Lp�n      �      x������ � �      �      x������ � �      �     x���[w�<����Zsm�$�T�)**��������,��	��k��q�<{�7���m�j|��|'#ߋ֧0�G��0w����F�3F4ub����`�� �_G�:&2Od�4P���f��|< [74��:7;s�S�L��Ƥ��@Z��A��8���Ӳ�ҝ�w�.��|Gk؛�N�2.h���W$E�mT�ȍe���y��bx�(��na�S7
�4w���"߆G�g�ۛ_�-�"��A�eDdr�\w{	���U�QR���Nu����bh�����b v��R��nڂ� ���s������>��qBm�1�* "#�Z:}�ϩZ޹���q1N�LR��a�v��J��ؐۂ���<"J2��-���k���������oUۙ�@^ �:�0�x�I3v���_,�ȼ��'��yՋI�R��cqf�ϯ�Q���K��u�[Ehw�!�e$��^vk��q+������C16����3��K�?����N�f����-v�k�$�g�� #&t	�w�n&J�s#,��aeb�%���FdS�1~�r���l�ٓ&�fb��J��G����T(˴����v��ƄVw��diL}7w�/�r8�qY�S���%���c�S��)��z�����4pnF�q��A�[X�	���"� P���8���ku��r5:��|�h�i�%�`x񙫾y?k��ip���J�&Ĥ02�\+���L�u&��6��j�������-߭��t��$���
%�!�+�X*��-j����ۢ����"�R�e;^��;臊gD�b��5�Xn��s{Ϸ45z�� �(�6���S���f\��q�9Y`6�J��a�!�4k��fS5��s��z�?Νy�Q���(3�8��,޽yW�v���"��X��Y��q%]d�-�Y����}=�������k�b�|��~z���z�rU�E�@���uT�n���%lc��Z�aT�[��K:��^W/�_}���G��|�پ������V���D��      �   9  x�m��r�@���S�����T��Ҡ��l�����O�Rr��L�����M�|[���kaj[���5A����Cb&�.đ���i���V���O�,�ɸ��
,�YAW&�)z�P����t��p�~����'�g�qs��И��`Lp�h�� ����d:��}���;7�-��z�@�z�<��Gλ�:����_w�1ͅe� �< A0Lok��(q�P�����
C�B��� r���:�?�ё3���<N�$����/T��C������1�b$j�2pL��NV$�Lۼi��;v��      �   �  x��ϻ��P��}��� h�r��*P� �+����<�n���$S{������N��ܪ'��U|�fo��^�7�&,��g߲�8���/M���<�0ӑ��6%p���3�������������S!6��F����
�IP���1�D+��t�b�IP����%�y2Q�0p���3��;��,Aޏ6�&A�g:�m��vt�*�$(�̵��,���~����$(�L˨�2h�]n�< n~�'8�2��7��t�IP����8,"%"ϼn~f*�f�vƸ�����$(�LA�w��Z�Z����&A�gGW��]�Xn~�*�B�A�����IP���~���w�$���
�M�����j$�nV���.������l�W�l�o 7	
?�	}ct/���E� ����L���4/�XL�E���ٿo�9	��P?�&��o���      �      x������ � �      �   �   x����
�0 ��oO�(��(�.�]�D� c�-[��5���'�<��'ɬ٪H߬�R��C��-�]f	��������@]� ]�8�R���,{`ȸC�a|B1��W@D�w�c��_�^�B�q�,ҙROP�>Uۙ�����iH�ߞ���7�)6H      �   �   x�u��
�0�u����L[��Z
�V,�(t�j��b�/RЅ���p��n��:�O��ix ���� ��!�{($�I�HI]�p���x�kmi~Y����A�˄c$S�7UV_ku$���S��1��v4Ib�J?�i�jcߏR	Q�!�Lx��ZT��zs7e\�n�J�J�*����`�Id?��.:��'��P}      �   �   x����
�0���oW�(��0=I��Q �ٲek���W������O��m"�dj��VâsZ3k:WBOh���uQ�S�o�;��Tb�O�\�(R�rТ�����`4�ldy�Գ�=�&�K`�8�}��D��|@i�1ߙ���1�`H�FfB^��7�      s      x���钢������*8_vt��T7���o8����Ɖ8�@
�(3��{-��N�PeUu�?�Ot�k���ǔ�Z�ę�tvڬ{B�w�eg	j��������q��/����C�T������"�M��lמ��h*,6������m~~�<'�:J��n�����Gs���s�L�Ҁ�?����J�,vcL��޼�k_~�N5m>���j�x�3�=i�X$5)O�$*�F�;#��B;��EkO��v�?'��L��2�Ē��ЊB�y�)�~�������a;㻬���n�5�ub��Ci��C'f��G������%�[��=�j1g#��~����Z Hi{�#���� JC.G��f�ni{J��M��a�A�8�_��ҵw������]�t�3!�LB��s��YXo�(��G7�a���j�\?(zs��Lw��:�o�����}��~���0�<O��b�%z��T-�H���=g}�ݵ����`�d�z��)��*��G���Ȩ|�ޓ�C�&�mV�S�
���Yք���*F�Y)tw�	=�8�q����l���<��b
��eN���	��ѱ�!���Π�h���X�БH@�>�|2�3G�]G�5�����Q)��W�w���џ�W:�O�3���fQ�����@�:k��iڟ׈1���cL�
F JLy�����^�e{R�*Œ9�c�8���P�h�~���*���p������#mO���n�%;��67@�&�~��Ө�X�&�%��%�sXT��_Wԍ����h�h�)]��v�%�7�ͩ�4�-��}�o��j��2��Fa���r�iu����~
���B�v-aH:�������e҃�g�v�n��J������U��o��A<�N����{h�	�Wc�8����8�)�� IԌOٞ$H]7���[ͺ�R�|�u��z7�zeh]����8�C���G��߲ۯ)���2="�o��&&nV(�'���a�Ս��jg�q�C����y�3W��ǟ�w�/B�����1�a�!��?��~}2�o�0���+Ǜ���c��ƶ��	:�����8�ў3��y4�v���eq� >��q���g��Ӑ���b�o�907�,H����bx�l^$���BR�u��� ��_�<�����+�:�m�)ݒK�]�+@�p`��ޞx
]��AwY�W���PL�b�.te����g�L��M��4]��$Y�����j�'���
�.�G��gI�x�]�'M/���Ko�a�"��L�Oz{��\�c4�/�5XX򝢢�b�WÓ��ck�_��M¼�]�P3�|(�Y�o�&w�F�ь���Ͻ��.^��+{�S���'{k���?�c4^k'-�@�׋�NoK{B1`���(}>蹨����Ű^U���^�_�r`6��-mO9�U"����#3G�sԓ�Ci��`q������9�*,`����Mtg�̲3g��j��y��a�#�M&�<g�X��E s�<�/Z{��t=a@�Ά�91� $�_4�ޗ�<�͵���T���!�EQ@�X����OY��ۃ�Z���j�Hqds��)�sV�ڑ#���y6 �F̑���{F{6;�ձ#��=^�T��w�[��d�w�)�%+w�(��᰼���@�nF�?�a�N�DUT�"'��������[��`�� ��nU�����G��E��d�{c1��+?z�c���)hm�r{Φ���}#��KF���
Xv�zƉ�^����c�G�w�^��<kAM���{^�5,�Í=���`GC�M��?�㙋u���p��l/nQ��x������k�9X�qh_���)vh��?������r�=�����GBt|�M���~~���b�T���z��<P�o<��k�1�R.�]]-A�f{���z?�'�O���iO�k p�����Î��7Ίi�Z[�������x�b��)om�3Z�'�)�ƣ��
s-�~����W�Ϭ/���2�^Kl�l���QO����+�����Pb�1�E��TtF�9\B���b�Erl�<��Q?�g���}60F�1H�K�D��&S-�ڄ��iO�5`w�5�{���O�@���[<��b��9U�M�\�tti�6Jo��
�(�Z5?̤�f����å%u�.d�tI���qM-�G�1����n��r�)����E�#mOq0��H��:`?�ѽ�D��s0����d���Iև�5�S`��r��b's�1��ȏ^U�30ί+�/k������(D �0�!
Q���Q�� PL�Ts�$��M)�^w�踢��;��DA哤~��"-�=r�ܜ�XV3T>u�I{��
�;-PM��)�%�S���N=�N��(aZ4���AN>��im�a���Bt��Mgb��P?Q`|60b=���|����28u&f|[0��lC	�n�G+]w&������v{���Q�:��G��=ŨC�2;��!�L�F�ؔ��G�A���~�X����ۦ|7u�J{֠2��ptqŉ�!�DM��bl�]���]��${��R7|
�s���T��y�w��r\��E��s��8�K�r)� |ߍ��EkOۭ!��cy6�3j5N��[�����քӨk���\@�0A���1�䜚�O|>٠�r3���C���42z���L|�����8J����nO���؇RP�b������K��K�^o��t�B��>F�8<���A���`͢>�oK{B����L��%�H4�D|��w�1�#m�:o�t0�9�C������4������\v�!�}ׄ鋆q�'z��e����-�<�(4a�j�\�/V{*-*��.W�^XC�Ɖ�ء�(O���?�bx���$٥w�9���F�S`� ��������� �O� ���A�d潋4��94F'K����`���\�PR��k!�������6�(��8 g˅h�n�<ƹ�"�ث�y�d��sm�P�~�1�k?�n���@�c��#R���S��(FL�.��jԧ�����E���}��SG�6Z�,H�>���1��O:��>���\K��'e���'#>������f/���_��4Ydk�|�OU���fg��kMH ��j{�bQۋ#L'K%�z��o�+ίz{�c��p�s[G CHu��2X��;�~}��S�+��ݫ�0�m<�'�5~�^�����9�շTD�L�bx/���P:�[�=�n�E����d`��j�ۍE�<_,��)$Vn��)�D�o�31"��veK��\�g�H�%F�6%]4��5R�A}A?�S�a~��S5��^Vb]�6���a��rs�*�5�F6:�0tb
���/F4�e'�r��w����=I���޼�xE�k�@�������gc���=�������"�'8~Ċ�1�Ņ���*^��c�̢�;�y7㓦4j����.�&F,���0�#&9s�3u�%�]b��䢮3�;��ף'����1&��|�}��z�}��A�>���,���';o_
u�!�%�8�'�[n���ƋTO��}��#��~va��l�Z�eg��C�~�����J��$]�#�;�>�[s����d����R�R�㗨���ۂ1���xMƕ^�����D���/ߟ��zXLO��z�T���=#ڞ�W�ZM�Y̖���a���Ɋ/��If����S,�x-(�_	#�a;�ܸ-盩��+����mJ�X��EkO+�P�PS{����B�0Da�C��X��c�š�Dy>= ��E�;�i��z�.W���Jstn�V��-^5�md
0XP�:.W�	j)5���L���X8�k������86N�3#d?O�#�f���rwJ$'�� ��=���t�L���y�o��6)�ď�c��%�
7p�?��,u��kF+$m!����L�{Ҟq�5/9̄���B��,74��&���"7��?fb�9�^�"����<8O;3��s?�>��,&*M�2�Ù84 B�5�%�P0���$�Ko���t
|�8:���Ӧ���w��L����
1�X��b    +e�tc{R���{�����]Rq`�:�£���'X�C��e*c�Q��N��,p}7"X��gc��6����>ՙ�f~��~�0汬bN)�~��~�"�m�$}���j�/�/�+sǡ�'	Ǽy��h���8#��^�N�s1:d��+:�g²���<k1��Y'n��97�沓����vQ_�^r7M??P��L�#l��^����8%QW��0��w�1��H�8N��Q]�ag�!7�`����<<z���K5�,
Q��Q��,���(HuH��`�'!��Ix���B�X��A��i�E��nK{�h/��A���֙,!��h�i�$؃�8��t:IΝ[O�q�}���!*`��� 	1i���}51ڿ3���q�wuҗ���GOٞtQ�a�B΋^S1�u��|
�Y�<kܣ?fb��G7�G��򸫶߿�VQ>�XS�
m���t�'�w��9�d`�L>p�����F����`��CF��ئz����_6���z#~���JL������{��|'Q&U*I
О�m�����`���Sd�8�������'��)�O6&^g��1c����y(g�P���fS�.1�R��σ�պ���]!lx��~b^7�4��N���܇Є��̾X��-P�����.�ʃ�v��J����)���6�4\��A�i���鶴'�=�F$\d'��<
�=i��Ux���=�Gœ�/���������>����4w���2�Umϻ�zr^y5��C��]b�z��n���P���Fh��]`��(�39OG�Z# ���F�=Q�v��.ϭFL�@	�9�mA��y	��}����Q��c�z�� #���`��C�E�.����)0�A�����_�3HA=F-��0v� a��:�Fyb�c&K�r0��4����掉�F��Vq>d��`}(6:�$ &ƇҞ%���d��~h���� ވm�[-ݠ� �=��l���M�����۵P����˝��y[��Rb���՞�� ��7��2-�����7��a�'�°�Q
N=����c�OC!R�B�����v;�@�H�SiÒ���:�+{��{Ҟa�u�P�;�V63@�Q?��?���-�oت<���d7�7y�}O3@��aza���ᐿ��k7���c�BފcE��9i�6��B�q�K����Ĕ�Yﴣ�;�!w�qA��ўy�t��U�F���ȷ�tCχ���LW8MFF��/%Ǐ�"3��/�G�)�E����xa	A�K@�<W��=���ϲJ���ܿ��@�=懊Q��B�e|���t*v;�r�7wu��Q6�X�R,nv]0�S�������p�\b�)��Fr�Vn׫>4o�س���̝iq1B�-�㈐�}B�|B�%��s&F�j�0�.�\��>��2��K;��=�=�.m�?a%�Dcdfޖ����}=��#��f�ʛ���i{�*��^'3�!�פÃ x.�G/Z{��SW���aL�ǣ�ݓ��]�͢�lrY4/�x׏�=eH�p��A���Evxx�G��5���ȸ�#y��73���`�q�P�q�-��(�7��d�x��)g�f����8�Cܼ��b�3�w�)�ˋ�^��&Q�cl��d�����@�#��5
ÚG!
�e`̯,L�]��J����A��rӫo���:=n8��?�_��=I������A��gAzO�3wC�݄�����ݼb��c��u���{p�+�9�y���)0��$���p�E�>Yw��ӟ������2��������9��_ʗEB����v��k��9�_q�`J/�r$\����������ݞ�{���U2N�Q�t��nѶ}��G��Y_�;��u��}��E���X��p{�\f��@)����a��D3�r�rd��&����*�a%PܠX(��f.���h�{Ƽ�Yl��l���Ja�Y*���h϶FS�(�|�g����/��Ua�0�i?\IP��^���!��V?���tp=��9w�v����G����n$M���8e}#�4�{Ŀ�E������C�sA�>�~�S��^x\maTY�)+�尳0�ۂ�߮�C���̱7�7��4���{���Q���K��M����};���f��^b;M���UoOܤ�%�W��O��~�,���ۭ&�tYx�҃�b����������5c_���eg�x��w��_�;�����Z��m�}�+z]K�9LY.���7O�h�i��)�N�.�#D{}�����Us�hz��ca����c&�#��yA�V@K����7�5f�#�����v9¤�D��,#��p����G�
�p��|��+����:'��	Nb͋��,��pH>F�V�u'*ݥ�sgQ\o�^.�1���E=ِ;�[�6����{5j�Y���e1�u��H�I����^��ą�9G�����W��|�~�8�+�Gy	c�	��3*� ���EÈcf���;�c(��=:Z 	�9��
F�Ȋ�}n�p�O.
�a��in
��O�aw8�������$���g����e�a����nƞy&5����tRSv�J7������#N|�_�Fy�3*�/�����I���u��Za�$�)0����n|8��A�2w[0Z���B�V��h:Z1J"���K�,:�E�4C��mGL�ۂ�7�?�]^�6��3:b���m(�����Z<�M�#B�V�g�UŨCci2��*�^�$p��)0b����7Y�S�$�i�V����$��ce)�ˁ-�"�n�H1��^6%ǧ(�tO��lOj������>�����as��§�8��5]P	$�)�EG2�=p=��Umϛ������Ve@w$�*�	�og��#c��}��H���y���ڞ�p��p7��䔹(*xJ���T1�C��/	�jO����~��S���8����(,$f�8�yO0���?��VO��SW�oŉqM��4�8㼆	qh,��/������R6��b&��z�����3�j#��%:�6�ӌ7�~#I����cum�u]�0gcoߑ\�zQJ�\/�A��_3ڳ��К������P/�Z�=��g:�1Ѷ/)�N�v�z���ч�1>
ku����5������W ���/�e�g4O�5�CL����T�˧ݨ��f'�τk4�¯f{�g������uӲ�;޼d�j{�z���q��e�q�wn�L�B��:��l�Q���`J��
:+�#}0D�+���|准Q��:�a�q�U�(L-���w�����е�۳���{	��F{fz}���W]��G)i{
-�L�y4S��f�if�fg��d���jA���҄�i�g*�Y<�·�Xf��6W;R��a���(>vJI���e�v�G�1�b��8r�'Zw� ���-m�kN�l<���*n� >gK��A�9y���خy{7̇�1g���ʬ�m�u�nڼ�:H_���)�&G�*������T�������i�i���������}����<���A���� �j�������4NMCu�1��{����Aex�ώV ��ș]�y�p1lVUV�/�y��'�o������F_�tR0�t�b��S`pEY���a6 ��w7ў#��V{L�%�P8��)�s
at
�Gj�uu�7��qS�`�2ZּKy���L3�(`�އ�1�D��	��&#��M�YS7�f����]A�(B�Ӣ�i�i��#�ݟE1����D���a����<%F'r�^���l�48iAd�w��v7�Ӡjn�V;K#�-�	F_�w��=��n�:K3�-�o!L"m8�EQ�3h��miO�yb���[O-׼��ҞE��c���F6�"�oԏ#���zU�G���ۆ��oh< �(� #��������@>'n&� np��U��V{j(�X��+������,]����W�HX��Ӷ���s�"ǽ��%�A�W#Vs=I$=�T��А����
�������t�I5:Ԇ��4ۖ��    ����f>�MA��h������Q�t4�i�0�tPO�1ʥG�_��_H�� �	��%��_�^�.�!/%�cCp	ջujj{ސc=f�UmJ�bF��CiϊɅe�6���-ܼ#�������'�({���O?al��f�m��B��_���4/Jy��sx�2���ft�o��
�޼��7�*���L�}�L	X�'�&˕���iu�;K߸-�	��d�X��o�I���۰�7f�Ϩk�爛��!:BQ�<Ts��Ra��]��\��ZԜ��ߥ�'���'
C�'�K��69Ӌ���%S���D��f	��۷oز�����1��zV6_՗��:�Ŵ��G\���Ű���[�xS�U����h����:�}B�p�EŘ8Q'�4�R"XV�1���S�:���X�����z��Մ��)�s��uo��]��� d�����H�����KzN�J�5����j{�S��BrǬ��i�6�c3�n�Iǈ�W[�rK}�
���b��y[᫊ᡆP�Cծ�R�Խu��|��ݞ|���ĭ ��A���<͚/�=%F�(�6�R�xs_�n�Y�S=FD}�W�rc۰��� �s��C��7�t����m(R�Ag�+��#֓�Cf�g5��Y�A������_�\:�˱3`��� BDhQ�/F�|����_���bE7��	�0Y�q��z�bS8�JQ�$
3&���̝9	����	s��{������E~ �^�]n�=
�?��,߫-c����v8O�A�gu/t�����>6o�C�x���P1F
u<RNnV$c+;��{���1�b6�~.���Ҟp��3��ܥ�1@9z�Uf����֞�k�6bk_P�<|��zU���]i��x�0�U�����Rл��Fe%E��+g͢c5w������ڻ�w��6��D�5�Q���i�/:F_&��t�>��.�N������1��Z��o��b?��ZgU{����8�����g�f"B�����4�wٞ49O�L��ꒌu��Y�7_�P0FeeE-a>�WV7�ǝ�����S�'qQB�M$���Ŭ��� v����e�c�(-:�	���Y��0&�1�-�{R��_�1��,L���cmi�9"�uDa�I�8
)�VrU�3c���=�/3��cc���}ggn����&�t��}ٷ�Y~|�n�n��jO�kM��|�p��p�$E�ԏ��_�1�V��X�]zM��j-�{ջ��Ӯ�}^m�b`����#~sIf_M?�x�R��Jo�O�d�!����y�=�=��b-<=9Vg*�w��Bҧ��W#N�g;u��3�螴g�+�V���nt�ߊ7�!}(�Ysq����&Z�����4/�l���,�T;R�HU�p��`o���Ę-��E�R��}<qɝ���7��N�{�j������4
ߺ}�1�@�;R�WbY$g�r#5��x���y�[�!;Yz	yB}O��0{
�}]��pf����L� ��wٞ�X��<a�#v�{nWe_u�k�B�ύ�� �8���'T{91cxX��6�o� �c�k<`)�[��Q��j�Z����͌�߲ۯ�p�F��1(Z��Ց��}?� ��IoO��E�^��`O�\o���~~��7�7�B�V�Y�
ꓢ��ϯf{�G���$㳬�O���
@Sg2ׇ������1�}�tb[9�ٳ�`���#VQ����m�Y��e���	���yQ����dx9_�|�INh��[�y�Z�\/I��S��*!��<�k'�E��=���e��g�p8[d��O�_���6���:��>�L�o��P0X]V�{��^iI� �葶��Hxe6�|zQ@ԅ������D���Lq_��8cU�ӱn0�ۣ��EŘ�(�]0%��d(�=�����EňtF^�[y��Y�g$K"��,��bԺ��n$�A���ȣ�~�1�w2�@��Щ���W�/\����WhL��	ߑ]p�B@�EC�-��bΐ��F�9��+�_,�Y�`�a��y��ֈ�&	$& ������o��Cɭ9w:B�8��&H����cxu�3a͑8U���E�(�h|�������8��H�2��f&�bďY�ғ�hz��YP�,k����U���e�a�y_�-'�A>*I��jO=�G�.�2�O��>�5�E�_U�����fX+�It욇QoI{Ƒ����k;�F�V��Z�0�]�x$_�����(C�R/�Ԧ� ��$�Pڳȥ���e��-ܞ"����_L�Q�k)�PSy���]GN �qP��`��A9!��l3�����>%���D�9_.7�<e��F��W��z�7	FQ�����_#�gE���j�Q�g-�WN�������KƆtN^��R�M�~H�1���G�m��2�QG�}��������c���\d�	d�/��b�Ѿ紧���׽��MV(H+�o�O����	8?���~*����r�V]�KFg�k�ڗ��+eh;v:;'��u69Ț�Y?%�ר0�Ϛlw����m��3l�B]sW�UG���vﲂy�R��pRd�|��a�j�=)H�T�{vi�����/��P0|��7�^��I�U���@�䇂Q�z��b��:;I,��=��L@� #"�$���}M�#>p����X������}(=��_��u6G�9�����Ҟ�L�&ݺ�.Uo�D>�H�+#�V0���!�0z��y'����gbQ,
T��E���M���c��2ڳ��x�N��\���P���a��f�~�s1��*%�N�X�'	.����g,lK��Id۪Sn��b}�.����E���L���i"h&bC��cD�ζw4E�;�z��[��c�f楇1�0��ϊp���W�U�O�ޚ3�=�=��&�V��lrA�$1>L�|�1ڡ2�
V1Y�&Gj���L���{�>"�~@��7oH�c�ў#3�Hc�D��mv�)0��pp�T�v�B`�}��泅1Ƹ�1�H*X�+Q	;�L�(���0ƙ��z�%*JQ�-wƓ�E�eǨ���Y&�����'�a;#�����s�4���,̭:�Ն3#�[W�)7@�և���ݭ�yQH�#��د)��rЫ�qT=}�ʧ0��=g�_�����J�,�g3�RL�C��DKGn�ݫ��?�c�Ly�b���"T���~;�Z�D�ҋ���X!���v���pF������w���E������~N%�V�'�{#&��ϒ}�0zx����@VF[װ�/E^���SbD�+��js}��ȧ<	���_��T/8�*�N{�0&������=C^��i^N�hǏX�V����}<JM�ݟ����I�H*�Ź�r��������L�~�:�$��*�%I�#�;��5���ʒ��qY��e���?��a�%���،si��W �G�/��_�1j���=��ͳ��O�_����ڐ�z����9��L��]b�TP�F��:$<��P-�)F`�Cr]'�QKp��g7}2�3��t��͡?��8騿'ď��?_U�==e�f|���5�ӎ�|J˯����=����d2����yA�Mp(8��X���Z�u�䙀ώ�����]��wo|��S���;R��u�R�	b��*N�������[�+�1�De1λ��!x�>W��|!1�<���~�>o���47_�+X�ΈZ����={Ɉ�����^u���.1��8���v+8*��kC@r����������t�O��A]3��C��tJ�=�g"j�(���2��a37�=��#��fcD�����B�u�#tT�N(�1�������Ǜ�zs�'&�׈R��Z�v�r5���Ƙ,:*��z�EkO�Wvh5���F{`GOўS��=A�O��� f��H_���Ԟm����,Rk*^"Fh +z���V������`k��&63b	�Q���h��@���)3�s��C�>�[�9�2ى��;�km��XnDh�4��Z�W#r��'�5�����F���P�C�笕A��r6_���������S��0�71<I����~Gu �,���z{�&���    ��i��Q�s lj�]�� .�r�;�l�B� X�E��E�ZQ�� .�M<��@�K�������~}�lj��O�?�<�>^�QJB�hCNr��$Y <�����f�'�KqZ-����|:���$SVE�w>E���N��}(�Ys��ۚ�j!(a�0{
�Y�{��G]����< �,�^U�N�MfË�3�;3�^ �>�퉗�3������Q�����`䇁4�o=ɷ��t5�v'WB{q��r�ʛN�.�s�xIsYUIZ��6���j11���9�x��_���kF�� ��7cJ	9������^��)L?#�ڶvAu��_�;�a�GH���h"p�	퍛3��|
��|m}�{�ח�x����]��f_�X�	U����,sJȑ{k(�V{�`��1���̰ct�=����}�ў9^��񅙗ޥ��`
�H1����],��p4�ը�yQi{Jnr��>�Xk4Rk6�EI3���l�ͼu�����+��q�������*3M��#�>�ڻ'�A4�Sp�`����8�ZY̓��Ǧ�1#��-�Gy�ǅ!��NC ��F_,�v�b�$p���C���	��4Ծ��}U������K��~�����k�zY�h���v{=ԻҞee��aW�?�{i���ߘ��XLu�.NzQ�I��A��w���-�� fƞ�q��΢�G�1"L2O=�:��ƹ��h>Y��gf>�Ԋ�L�_�7��H1b�I��f}T7����d^U�Y8'#��b���ks���!x�h�X[+nY0\x����3`hj	A�n�I��v���?�_O��Nt�d�e�~���]`Qk2p����\sw��9��,}�W곅��Q�Y��r¬s�ɹM�5C����?fb�AN���r���pE1k�@`='�^�qiuM�W.I@=�f��Ϟ\�[�����<��<�N���v�ľ-Q4���i�B��Xn�K������c1���ܫ���Y�g.)n�����ya��5�B���ؾ��N�a9b�Y�A�rv����f�T�@��[�;��(��t�
��y����$ �r�p�'h�r7����˸��&F4�I=iiO�09�(E����a�{��R~97�sf���7qK}(3B�m,k�~T��{����B��cl�8UT5�pk�P��|z�t�(\�dե}�Jj�!�\�{����e�Q��6�;�'P�L��sQ�ɔ
&߯B~rDu���.9���쳅1�����Xrhh.�6��`5Ox~h�in�G����ʮB"��>��K�qn��+���k]��kDp��7�7!Ƈ��Gj$жZ��E�w�:l�"���G���nO^��&
�Y�p�=>6�ߪU�n�����H��ns��v�k������5V�]w%e�وپ���b�v; ��4"��2Zu4�y�#Ũ�8�&��L�D�.Q��`�[`l���qєN��H�S�+GF��9���UT>��@T�_T�~t�k[�=6�N�;�Ali�J{VX��ͩ�'�q/Nz1���d�)M2�l�^��7Ǟ��k�sG� ���곅Q����8�	6�]t�t�$"~hQ�z���r0b�D.�>3>�Cs-'O�7���w�w<f+*��=�K0 (?�X׸�����ކJ��jܝ��|��Q^4Z,�6��x�C�ܠz����Ci���*e�Cv������K��=�=���?�/�Q��z�Ű����?�_��+��Ee������x�"Ώ��)ce��6�(������[��t@�}60<�/Uo^�4�r@�0Z�\�wc�Y�S6I�B�l��7�=X:�߻/��jo>M.2G�.�71�gco��5 ݚ���f�p�fF���_��bb���E���:��կo��3��ߜ����z���D��6�x4+�UQW�tV�:So$?	ď��&F~��9���3�t�M�G��6lj�&������Q���1+cl���Q���)0��.G�q��K+�l-4���T�gʛ�]wd�F�U{�e���~�f���7c�Nc1,Fۓ�*G�!������ECy~	��� ��� ƿv��XQ�8�.� s��tY��{��iv��{���=�:K����ps��ldټ	�)1��댴8
N�p6I/7|� +UܹhIzt�*���#���KS}�%���4�~i���|=�+q̐�n��`��׵}�clO�����w���w���Cm�?w2
Aw,J|ԫo}�O�q���r��(����-"�}
���;X�p�v�kT�W<�"��z�q���{�}��nP[�?����?�_�D�C�����?ob�3D^����}��Ӕ�΀;`k�o�N�x�������Y��-:�QL\~(�Y��R]�+���XE��h����֖�_����&7��w���u^m�s���Tn��cdv�J3.���c��Ԍ�|�����f��]Q���r�NPi]����hh�4�u^> ����4�?���qT W�Φ(
���5��A_,�st�}�c�|r��~20���B���,�i�9�^~��h�d�����]�`����9�G�ia�eF��Ѫ����6���=���󱯓�m��D�<�+0g*�=��!�r?ݮST�t[�����߮M�:�æƸf�=FA��ŷvp��� ������Y�
��7��޺A��W�=me��?����}��h��Z3q�<�G?�=�=?�Ld�u6�95:ty���L�9m ��3ڳ.�s�"�y�:��)F�����:�(ɪ�+:%�O��S����b�����q���e;ZmG�ڹY��a��4U�����4_;�_*!���C�8�V��!k����w��i����S�"ux��HޒT���}@��y�I��g����sC����M_)�UT�g`��s�H�JL�\;۠��c��I�W��Go��ˁ5��ζ�D�Z��d��c�p}:�����bC�!8���$�9cꂨ��sg�>*W�[����L�lJ�50�aC�]��Pڳ���lH��$�LB���`�rcJ�V�{}畝�]Tk�%�<i[���&����="�y�H�S�2#�V�;EV8�.*�L��7��b��F�>���`�JJ�p2��^U�����҃��lX���#mO	�*�LOpj��CG���lO
27V��e��i��Ĺ�~����b�����4ᖝ]����O����]p)h!�`ʯ;�,�-0�O�P=SI�T�Ag��y�χ�1O�;��z^Hۢ�o��u��sT�?��\���V�B����	F�
������ 򧽶����4����'�{����[��1��7���1y�XJ�UOd=?�ag�ɤ����ӏ�f���ɱ�;�7@�Z�CiϢ��\�(���3�w���"��q���͜��k5/��9��d5F���.R�ǧ��~�����Ztw�	���t���}B#�Sb���X�Tv��p6�KDȲ{ҞA�y���_����8���?�!$�͗���������X?*��岂�9�ۺ���Q�6��rT����|A��-����P߳"��e�|��>}����.���ƽ����<��Kr���rRY,���S~p�nt�﷋|20z��y�;��д>�?0�W&��(��/j�*�2�=ۯ��gc;7".�����A�:�(�}�A�Wc�r����/i�D�ķ���w�=+�:_�w�u�9<�u��g�$�baD<��(�H���������b���.F��8E| ��>����q�Y�}�:׻�j?!?	��j��&�0
�X$�y=үOP�z�0�e`�L��MG����$��S`DH~�rq�����5����v�q6�BeǴ����U)u�ͷ��]b�Os���ZI���^����E���7c��Mߘ�H��&V2� ���d����h���f:8�)3����v��/�٩g[%�KpO��/��H����Ѯ�/��J���{Ҟ!T�����0_����
�?dU��pr�o�w�8��ã������=6��yvgܾ����l3+g�ޒ���X~0�!^_#� �  �l���(J�����nZ�;PB�L?���lNr�]��g�ᝲ�Ҟu]I�T��e����Lؾ+s$��z~��j)����z�c�E�ʎ@��cu8�k�?���C�����F��J#R�_�m�b'�����Go-n{*䁓(9�3-�`D�����p�j�0�P{v���b�c��G��Л:l�B�#��葶�l��z_�B0��Qy��E�Ƽ����Da7�P��ۂ�~um#Dp���i/�t��LU;���Ԑ�v�M���ݾ�+,e�8;�����_+��&K�3k&ܬ�<���Zy��8Կ�俩?sh��穤��_[緤6��k�y��!�$�IPc �����m���5�>}�m�j3���~��k8�SDf�1���*�Lo{H�#���M��Z��h�=�{V{���7^���rY�zH�D(��C�β�D��ֵ����VI�5�sYt��B�E8�Xg�@<ƹq� ���M���L�C����V���@/ª�jڤ����q:/��)�w$/�4,����d<�O����r�KEDE��ݱ���=-���g�Ų�UP��ۑ����N�$%cD��T\��G����KG����A��,@�2�w���P�ɱ��T�:;�7��h[��oJs� ���4B�p���($:���CR@��U"�05"�3)���.�?�������U�^g��o�6���5�� c^J�1x�Q��gPw�ۧ��a���      t      x���َ���?x��),�t�?uU3\wc�ƀG}7�d0�l�~�~�~���ʬ
�d�R霪�ڱ��5�����>3�	�s}����χ�%��0���E����!N~b��`8�y���g���_y��/�#*�l��#3W:�����1$ER���҅��f���������g��Cb��?	�'9j�U^Y���/�ɦ��\�R�	��S���&Rieŀ˒<+��(a��}l�sm|������x*͗�����e�9�2��ɍ��E�L���ҁ�gEU^<PT�0P*��ˤ�C��DRM�c�Mh���NV����V�MK���^�v�Se]���do��=�8A�x9�����xvjY3����Ia1Ĺw�|I�bn?Vd�^�"�|\o�H;�~��jŋk1��^���"���ߢ����C����)m� g��%�;�§J�s�aZyE9`Sw�:�WfE�/Ӻ��Ѯ��ᶎ>CiU�}��^��ʁ��� +牧0B����*P�;c]����t���L�ث�������9(����Qn�ͽq�x#[�C��%x\��kTr&]zw�јV����ԡJ@qs)u�j��#�2��E�*+�,�o׽�oi��uy��o/=�x �E: �H�����0����BJo���Gݘ����7^y&`�q'ݾfq�������Ѧ�BF(</l�"v3P!<�N��u��l�g��t�������'<d�y��N���\��"D����~�Y5qG��hQ�X���s�Ĳ�p�ڞ��U�]��y�����brk���a�����k�����R�G��N�!J*<gq8|�t#t܍>O�h;���!4���zE?N�p�0Q���'�a�P�!�C��LGf���㥚ms��2��$�����ʲ��k;��-a	~��찪���l������J�,B�����FA<���m�M���u�����&�]`���+Rh��`|�@��������ߵ����;N%;���'D� �5T8��_^���{�B��a?�V�t��u�9��W���-Rti���W���e��#��������at�|:�W�3c�X��(;�~�|�C]hT���U]&�s�Z�(����'�W��2$��+�����Ru>,z�Z�y#k!�5�7 �4n��R�b���#����٨���UQT��y���z�D1��$L�XÎt��- 4\/����=��=��#�U%G������)��OH�N�4�+���q����F�D�ߺ?�����q����I�jm((H��f�0�//.)XXY��2��8y�x	�"�{
*x;�mB��?���2K�++򒺧g�����:�cp�(�@*��4��q����=�Nԟ�ob����jkOyn��I5���u_n���㵣��>)�K����+�����5�rlV��%�tL�����'{MJ�a�c<�Z����=*�e��X�e<��g��˛�D~HO;r�*9��|�:3�����z�7
m���D�'%���k3+����\K��I����Of	�:=�"��6Vc�#P�I����>D�Rq�6$����������"�����}��
��~����U�z^h��jR |Wp� �w1]W�i��Q�w i��ʜ�5Ln��b�B�u������:%j�,��Y]x6�G%��>�� s#�w��v7�l5q��);�^}A�KP�^�Gвc�2���v�x6�E5G���r=�[p���0z=��ƹun㎟x��{p1���B���b&˷Jl����@�G��].>þO�<��� ���lD��9����hq
�*��j�8�dJ-fA��P�+��)�M��n�j�>4����N��T�����:~�v�Gq�&��]� �(( 5|�ݽ8np_�\]�'�����.^�b���N����p�o�s���>$�!���g.�g4Ec7J�����,�S`�4jG[�Ȃ��S���~�_ ������蚷C���ꪤW;�tmy5��D������|��V,=ۊ�9��	�P����a��&�P>LԜCT�.�K�״X���φ�p3�̈�N�9(�E^�	�����.��g��gA�NP ��㲪����sھ��q�]�#+A�x ���`6^�dc���u)�$�Ay�p�����ȦN��=w�.��c5E	���K���us={,ixA�7(63�O��u�7V׬�>�u܈�����M�OP���0��u�&<�JL��ͷ����\o1f&&!��WW>���w|�ύ��7L�N{�Y��(��A��������#é�R���VӬ[@c-�PAZ����6���/��l�����X��7�U� �6� S��D�_�vQo�ּ���64�ơ��Y�_C��%�&��$/'w$	��ﷴ��tZ/�M��k�P�Rw�������{��Ҍ������xNq��*M�_�����ω���k4�*4����~|��N	��� �>&�|S3�9Aɴ��|�'u"4IS��'���Kf��y�g^�|�t�_�z~�"���3*��	���o�L�%�QY��"���@o'++������yx��� v-��yu�2�� �xWI�njz85�e^��r|B?Ą~��/ yn���T�l�n��y�����WuT4�p��L�{��Բ|�f}q ^��l{.թe<��-z-T:�ih��(��A���h�d��Ha7��<�.ԡ�(�ɇT �*��=��.���mB�S���(&�M�KC�'��!4v�~�e�"�$���q��f'Vi�k������cJ�����š�*�0/�6�� $����Q�u�B(�=��M2���9�	A�Q���S���a�Z��c-�OMy����RS4�7@:�I[t�_e�i��WRv�h&����]�~g�8�xx�-��*�	�*�ׂ��<R�]�~P-qi���b�m4�+�i���輟D�!Fz���eT^Q^в�׺�N�5�#+�%w�I�/@�%�0Ć���7��34���)Uu�W;�l�M�h!��cҳ�W�Ca��8+jM����u���ؿ��,S�5j=L���g�`�6�I�_b�J�We��ny��L�Nt~���'� )�Cp�{��#r\h��?X�?ƜK�)6M����x��2�E|�����p��t���eG8���-�����\ԏ����e��,�=%i����}\�,�.=I��"�|y�����Ȩ,�V����*������тEk�,�m�6� hC�eb�n����A��(V���v>3R�LBS�����D�����F�������ñ�D��O�y�	RH(���9���VPyQ�m��X�N�G�聳�}!~F\�r��]�����Z�~'���ʠ9Չ��@/� �����5a���cq�y-�����雳"���'e��3�Fӗm=G�r|n�Rh\I6DC<�q'�M�9��7�dȫs�Aa�ȍoD�.q�>��K򗋺d�I��3��E�qd>)W��E7����¸^���dG�B��y���V��%�v����IӴ1��lT����Ԏ����k:J�"T�FwF N�Y~�-O<g�L��H�)�;/�CHMgB�c�ݟo��!kሪ�B]��e��O�mT�����y������9��^ɩC`_м���Gd��(�	0��y�R}Ë���^�4�?�.�������g3o�ط�E-�V䨞�Y^���׋]�y����T�ſ�t��M������z��,|ϩ~��2r�Z7z�!y���� �z���([پ���<&������e7�I�/٭�)�F.DPMo �װ�o�����B�����zԸ��>�I+1@E~�t�����1{�|ѐ�FFK�<�|��-�$*s34��t?L� 5\�q���%1�<5���S��Vp@�T$:=c$�zN�{��*��g�-kk
��BF/v�mFG�I��%?�7MD>0��ŕR���_��j!K���6KM���x"�h~    ���	��=\�2��6���0E5��C��ӹX	|���(�<`��j.];Q���m]O��iß�z�s�{SQB�Яm�I5�ϯ\9ߎl���������Q��]-���.U�S�HTQ�� ��G�]��}�/��u{I�g
{�Џy-;���t�0穯i�U�V�s�C���d+��]mJ�������_�|�w�
���qT���������4v@�fhtT����Ԯ�K_�Mt����L]X�"(#�������f�9!��:��w�¸k��L�>=�6�y�vի �y��w��tkgMc�d���z��G:dt9y�f8s�⌏�uA׼|LE�;����`4ǁ�W���Y����6+<�r���?��}���L֨�4�g�2@-�Z]���=�0綾���˄4zF�Nx�62�8�-��,*@�m�fi���MX���w��?z�� $�[P�4�ҍ��� l��9�#n\q�2V�ꎅ�@������o�\���g�0�Y��Y�抉vR��M@O!>6V���#��9G�zݦ����6�t#��ϕ@���舖h��/�Jg'8����e�F�.����	b�4�D��#�F�� ���]�8ӆ�)�v�+u�?��Vc��~���C}�+�^���m�o��EӃ��zU���\<O��|I�n�2�İ˾�2�	\�%�,ْ>��U���~!b�<Íh{����&W�S
��-�jcQ���b��PU�:�my^Ytw궙�I�r�C�A������_I�K/Ta��h���ԭ�6�6�g�7����s�a��DW�.����Q	o΄$��`r�r����-�"C��9���\hAO�KSd�o��>�nV$�Ұ
����=��tԷ��8)�������;�{����"b�����f�*a<&}t3���E�����ўF�&��*l+�ۮ��ݑ\�l #3�PN����;��@��3 ���wR ]��蕼��L�zi���`Lm�=C�릠P�#���3�N��V�)<m<�Q�����@C�1�l�!���	7k�vب_�Y�.s���A�$�/r�?T�,��徾�Mףp���JQ����c'�:׈͖����
��e���Eq/*�-\�����/FQ��2��뜏�F�jz�J��OPm����N���fD���H�9tT����;�x��pv��X�Z=	 �o��:���8Z�ܛ)
dTx�o�f�9�e2M�}p�R�H��v�^�R����7�&a���hD�Z��q�e�0�픚@?e^ދ�>F���;Q�75�g�LO��P��gh�0�)�?r�\����sMKO���I�Q=3<�݅�2��W�G�.llG�9p�?Sx��m�7�Q�$� ��f��k%��sп��M7ؒ��i�����������fd�Ӌ�Co|��h����/�Sø��Y�8�Zgm����V����N1��Lr\[O&����+3�@n���E1���E��j���>U���G˜Wix�h����ޫ�TZsg �i�d�Խ���о��.{z2�g�x��%�d[}Ɩe��:]CK�5��'��y���r�+��Stvt�to�XTz@��ړ?�C�*Ns�p���ޖ����`R7��W׾L � �=.Ǘ���O��	��4�Nvgۭ�%����E}���?��QxRf4gy���-�f6�k���~I�DY�Cܲ­X��HrA�|�6)�O*a��4Z*�iv�-��G�����^vsٗh�f� ,�ו�H��r�<����8��Ӻv�⳾�'�D��3F��2�=2DE��O[�66�Q�ϓ��"Z�����?��V$���Ա�$���
���'С�sc��6��Z�(��c�X�W�~NK-���djC9���:�4u�M|8gtꄆՍ�	>:_z��s�R%Tb#Έr*����~b=9�+>b�p��d"3���}�F`�ce�	�+��p��ۓIQ1`��-����Þ<���Q8�|��J�Z�>�cm��67k%��(*4�{9o>�2�!�< r��;贋��N��yy�܎�mֳ@���Io����}'�h9>����%z����'�M��/h�H����`OC�'&L>�L�*%6���"�����6`Y벃V$ru�'�?��|���F�sɸɶ�d����$ 6H�ط�$k��jX�u��qO~�pl�:hL����ÜJñ�ċz�{��������y����ם�c��+����������|�������/Rd�z1D}�,�AûB�𤬬�f��:RqN�v��J��س�C*(����|G_���)��I;�|����`�+<�p�b�ZޓZ�І լªG�r^`o��ƞ���m�}����s�a6G2#6��	�QrhG��U	h�
���Lp��q��mt%ֻ�R��O�^AK���^�EU?��(�oꓶ^H%s�ǋ��"<�
�hJ���X���0���尭���F��y�5�y97(�4�{�C�y��f` 6���uQnC���_�+�$eV�Ӊ?�h��� ���X��ɒ�|ҷ蝳�A$ ?߇Ɯ�J�0:ϟ�T	�4x�G՗�.�yi�yf-gG�@�H�T;f�g��;���Y���[�O�)�U���K2�k@�<K�A;����:l
����*���6����C����;��
��'�yX�L�;?ec���5,?{#;>d�Y:j慇}'���͏7�~����(�_W^vu�~u�.�ȨIx���,TF`�#�'g��w<&��~l/gS.�keQ�%���7�T@�����f��[KO�a ��R�����|����C�r�r�G�Az��Vx� 	��l�i��)?�S�,$QL����U��!_��2`Ƿ��	BWA�9��LbɶC.�nu}�$��}�b/����}�;"u)�r��D���bV����Ԇ��Ԣd��xR�
QL��F��2�����S)���5ڤ�F�g[����,���F�j$���X��h���(_��0���tԃ�C�ѻC�a��m-���GO�zL����^?����-3���m�0~�ڱ ��եv�Nsn��Wт��ل�����W¶lc�1j��8��mqxvi������Ja�G�6���N����m5�:�M�ۧ��l�;jǄynOn^��mS;�7����F��x��㧈�V�>vlj=���shL x�@ҏ���h�/��9/�%�1�dvuz��f9�����%��vУN��4u]�w:�����q�wLo��=��~+Y��������� �H�����ٟ�[�!������'��� ��@��5]�,�ö�ȃq���1�d�N�|�������^D�_Ⱥc'�����uJ���[��>YDĳ:�������f 
��<ڸ;~�9�f���y�p���ӁH���D�Q	h�62�BxF��r��������I��)�X'�׵��0��P�P�'� ��8՞��R�s8~HV���ϊ�W��/�`�E�5��Χs��Ao�-M�3�h-��9.�"����,��=��I���$�Z�3S����挬���GQ[7_� ����PO���&v��IΑt�6�z�2^��������C�J�+=�]��� L��sܜ�̦�:��u��A�^o#���ip�=�'�qzVh�e������d�K�8�cr��X3ɜ����+n��;��#�^^�燫�獳}�9�,nB��jV��xh��_l�x�>�O�ݧ�t9��
G�ZM�b%E�<��݁�o���V�b�[�@��O
z�� ���.��rf� |��[ď��AW/؄o��g��%�@�ʡԑ���v��{'ͽ53�\]���Xv���P�u��y��-={�;�=4P_���:l����X��m��G�a�,Y{����3���Hޛ8_�t��at]��z��l���}�.��e�M�1)J�n��տP1��M��R�V��R�c�g�Z���{k����Q�vnR7�f�Y\wz^���8n	fO66��d�N�|yuBg��"#�n}�#��@~�:�D���49%�d�Q1��������%�Um���Q���N�|?Zbb{*�    �G�gBdyhVy�d>A�xF$q��X/����V�n¡̙n؜�7�B��������ur+�OGI��BQ-�\V�+��Q��sv��qI�`�*z>-��kT�HL�U�7�%+�)�z[��=%���b�Q��<b��@>�����|���I��hn�Q-$���O�������ik*�ұ�P�	1L@����%�<�9m����(�v@��eJ����(9����cI�������áXn��(�t�l�Z�{su���6�9h�q���"�����2!�䔤�V�����1Y�8��A���Y���C��i����NB�[�V�>183�j8�V�_�8��eON\_��t槨�2��ޜu�aHС�痆���q��!��u�
K�9�rb-p�6��r�݉u�� l��prt|��(�,�\Я9�0Z+�M�k���
�.Aڒ�	ؔ9ۯqwud���\л���%�u;}K�˳�e��Y��4�Mw�ꓻd�4�@�쑽�\��I1�Y5�[>ˋ�C�=�D�6�5�,J!�ۗ�Ӟ֞��F����&������O���-w6Ƃ��Q���{^���*^��t-�	`"/��q�tO�K��8��,�C��5W�2������"��O����{N��")��t�oV�u�kl4��Bg��Vd^w�g�ل�-�q��=�v2G50��CJ���������Y{
����&R�w�+��gE4�J��|IH�Ȭ��M��J0�Rp(Z�~B/u��*��9Is�´F����r<(�'A��M���u�Ձ��~������/�:YUK%u���^�,��s ��JZ���vd�G;|�J��A4��vP�i�v>;�^�8�*��4P^o$�!�@�>�ŭ�Z��D;..�5U��K�c���`�� ��|�_��Դ��~�� M���R\�V$��64P�ţ@:<d'sGb���.<U�l-�������Q҆�"��ksZ��GŅ N:b7R.,\���٬Pݡ�-L�.���ֈ����G�iP(c� y����6�e�^4�d�g�(C��'���-�)>O�eR]G�[�ms�w!��I�Ge���Э{�ؽ��\�X�]��a`x��=�}���Ń�9+�M��ѻ��%/���.AS3��P�'̹e~>wl���h� ���N�{���e+��*��KZ�*��\�أ�/:�:_��u���`�㓬�{[b�f.�%��q�����V�!�k�_}g��U�|4�MS���?�}��zDp�F�2U('��$�
i��u�5�#V�_*�N��,�ą�\�548ȺE��քiԥ�r:�∌�<��7T:��v^^t�pI�#����WM��%��?����ʡvi������]��P�ҠX|�#���NB5�=6�|��
�j�j�:G͜�?���!}0��Y����ܫ�6��^�vT;�Y�^.�"�!�c�
Z���v�}�f���p%TÈ� ,��Du+ִX�Irws�i�A��E����PgL	���v���Jt�g�PZ�`���ԇ �u��1�d�fk?mls�mQ�zo����|ͦ��k��bz��#4t7��,m-U��(L7��+]�o&�͔=޻���J�[�T5\r�-]�\�4����KZ7�a��P�?���F!+�l��;lg�D��d����9�m^�����))4Y*�~��6�O�j���Rm�F�%?��I˼��D��1w�����^����f����Pچ��/���O�=���E۠D��ѽnD*�����z|��'�*f�}������wI�Ga����m��Zu�_��X�d5~�ַ�=iZ���+0��PB=-+1�^)+k[��0�/ќ*P|ed�7к׍4Qn�{&�s�7��߲��2i�`�N<hcA�Tks��7��h-�ٶM��j7��\�%j,���J�@�X�!��aqVU�O��=S��X_�!3��4�t�B!������Xz=',�(�O�����Pd㳗fu�8ay�87;�hF�$
E=AX�d'���F�ɗsqP�A�_k��4ρyՠm$z������S�b裪wR��3��g�����~�Y��)*%����4�=]ݪ�h�DxQ45fW(P�2ן"�A�9�T�3{o�A5A�p\�=~]T�ɽ�z֚ �GO�2����1��4��!h�[�1��f�A+�.g�ò�g������ē����~H�f�K�FT6�z��O��lQ���^���M��<V�)��Ϟ�����_&�.��Q7��x��ᑵ>PGǁ�E�g���߰G40$և��Y� 銩(���`�&�
hS�lP'P��H�9O+�Y>z0wC�i߲�kp;�z��3��R�ڿ?ts/�Ŭ��W��W��WcOG������n���2����6`�W�3�������U�f��&��_���\�ӓ2�I�E��W��]NysMq�gMx��y��j��3^��d:�j���-�z������Q�u�K����\��o㺦�m�'�h���'Q�x�=�v�F�V!Ё$g&h��s�Q��?%�$���Ӏ���Ɣ��w�.>�g����q,�!j�>t�;�l�+F	!^������>*�w��3?�Xg,O�h�G�T꽕�^�֍�¨�	�&�[5M��F�B(Օ%���D�S��E�w���{X���ݥ�96�̵�s4E�}��7uc���})��֨|������|��e㥋9�u��t�^���a�@ݞȪ�;�CB�m���:a��̟��㶮�QM��FL/1����yZ#|��'1�?&cul��\K-s^��E�����?��]��;���٩84r��Ӭkc%Ig�V��.i��[��,��Hmi��3F ���P��QsBK�>�V~6w��,��T�)QO���V���<���jr�=�/��n�I��;�1߶�#����
�C➺_�v�ZDs�
GZ��+�m]� y�(�����v���{�mk�N�c�hzd�E��(#�Q���:�Y�=�F����_O�K�.�ՋcL��@^�eK_)���@�] =�NK�f�ǝ+I���0�	ԕm%M�T{>�	�oX�-�(�u�<|���4'���y����@�`W�� D�>��g����
;Dm�$tS�n:�N2^�W޹E�;o�`��l\���ۣ9��m{?���a�ؘaF$���7u��DV�&/4v��7��K��x���ϰ��!=��$�s8z6�	[��Dv�:j�D�n�����Q�x~����z���fw�2c7��a�5T���J%��:OL������MƧ�F���v��]���c�~֕|>ϟ���^��ݳnl�M6촐��+NOZ�b�
��8��Z�fKlXUZn߶���������U���3��Фѽ��}	��\ӽb;�<�L��$�A�X?�?>��#� ��C�w�Ct<�

M�x='t����M���������o�����@"�+Y\oOW%kӅ,V��#T��&�gnQ;��B3��-������ȝ�l�R	>2��l{Nf��
���Wl>G���<�����lk���vS����l&킼���h.�h��b����KJ�0�'�O��&ht��@�ӏ��]E�);_d�W��e�Jh=�~9w��gpG�r1�N��Bж�|U��n��g��R��'�k�0i;z5���Rp2KX\�8CQ�4��"t�Vŗ�oDlenw�>?+����L��U���-��^y{oF�H�'��Y�������RC>Ź��v�	J��Sݾ��5�$ۮ<��챛��ܴp�֊u\}��L������D�XUp�a�v����[�z�2jw��z�v�Y�1/��%k���h!�V�,��k�j��W����`2�>�п�0��i��Uh������ܾ-�}��ӢfeͶ�c�铸H@O%�:��)K��"��^P���xU�}A��2U��8fQNf�s�cb<�s>�CS�W�yWj'j�_�)��c�p�k+

���c\_w�t�35�4�pR�1��d��K�^ �����cd���8    ��w�۽;�DA#:�p�A����cƵ�.V�	q��(�,I�%Է�x���B�.ʩ��4=��8��p��8�no���v���ͬ\{e��&^)��DP���Ƀ�_���^��[&��Ю���ƈB�dlw��%���Փ<!H��w��C��ַ�*҉X��`���^si[x��Ĥ���x������O�HzFV��0�1.�tD�Rɿ�����߃/��Q<+�9�N{4����x^�9$��0�tͻ�GTb�c�w޶~�孛��!R�̣�~�?��_���3?�VR`zQ~CS�YMV��T0U�i����#�:�ܳB�;�i�:��-5K���Ra B���]'7�7'ǐfgy�q�Tkp�]7L����kj�/���s�u�:��IT�J���S.����͡9�6��-*��o�,��S��U,��}6��tٯ�8a�$��"��OJ�B��wLV�~�N0�(�<G'���KN�Jo��o���he�vf
=��M�� ��X/���W��_��]MͼH^b-�'��~+�xy��1ʱd��l�l���V7�����۟�F�mhQ�c�ӻ�R���N؅�9�6�����]�� ��bzB�u�
�'���s�\�&5�I�#O����F�dw��-~:ҫqH5'ု��iͰ����u	�E�s&̖C�FYՄ����Ӽ�_�V��WU]��<�D̙PȢ�ߩ0stSvɣ��;7�Q�����g�MW�8.��\z(z�*���n��ʌ4�̓V��m��T=�ag�9�9�kg�v*�@+���⹝�����797>F�h����\a\&\���v�=���H���C�Bu�*v�.Q�ϩQ�u��f��P�����Yk�Z�z��bю�aF*��;M���vC3p
(ϊ�����s+������.��i�kf�9I 9"�<F�(�%�ׅ��Q
vS�S�d����a��*ԡu8e��K~F��b��٢㍏��(�@�@��C���{<(kh8��&s͝���%:]���&���;�Kp����3cn������e�~�z������|+E�9a�n�*Z$˓W����Q(%d�;�y���|�E�Ԥ��b�G��+zf#�l���F�KT<��f:�`}�n��H�϶�\���9��z�W�HB#���Ux��B���ԃ��ߟ(�f����\���Lǂ�:�j�|�t�g`z�.����'��º�4� P�[���~�H���Tۭ/	��6D�N���g�[>s�91��������{-qW����f�ӓ�]��I{PG^�~�;WE�Q�BJ��D=M3	�}:Gz6IW�&��E]���
�<��*|.��'�g+
r1
sd��DX�&3��*�'Ϝx	������Y�+y�f%'f�R�A�Ҏ��ۛ-Ee-�l1�g���5��,�z?���(Txu��PE�iJ�	��Z�Z���X��I��K�>�����Țdmx�(��m��6c4A��Z�~��N%m�-T]��*��2o�%��O��;�6��\�8�����~F����0d��8z��k��ݤZ��rk�O�e2�k+���)J�)oJ�f�w۞��v�d����ff�,���[��/�)�1�ok�	ү�¿c5Aa��_�ę��=��ɖ����'kBX��C���(̬�
_�)�����/O�H���:=ң�M�
<PV�Y�W�A���l�4A�o<kZ�k�OҦ���4i�}��]��̚�J���Mv��?OEVf��#��$��{�i���W=��%�r�oT�4Ž�і�T� y���8�'��Yc�q���q��m7���?�����Q~�So:�5{E�y�F�n������\Uci yВ�}�Ð4K҄<�gF33f��3Է�1��/1����|�=�؄��S���o�@��PV��H����z����'�?�8���)3��9@ߚ!����m����oӵ2Xp�e���=�cb���NLu�.�����@d�+~�+p��8��U��%g����d�s���N��K(���]f�O�H�s���7�
q�8��X����5��ʀ�f��f=�a���b�!�Qo3�/F�t�l�$��m��}�6���g��)iP��������a��I<��R��:���@�m�s�:YoǞ�����Pl'��=���Ǳ�8NZa�X��).k���?��T�U�Ow�U���"7g��Y�֛;mt�w�xKT�b��P9P���Ay]h�����VX�?���F���O�������n�g������_���W���U��M�(�����@n�dm�Y��|ͧ�����j�U���������n%���%s�;Ǫ���0|�XU�����D��	y�jZ��K�#0$r��`"B��=��o��:����w��k��~�:����%+ώ�v�:����D�˧L�q{X��7)f4��{�Bb�PW� ,�S���U�h����Cr�7U?β�[��x�������سE�>���?�
��n	vq�k1&�!�?bo)܊S�U���@ߩh�Ch�������yn���%����ͺ0�~s�i�>����4[���J(�*Y��|5d��E�׬j-���K;Y|������+�����	��3�+��N[j6���8{#V��hVx*O�7�Z����������P�������ή����*��j6���>���eW� P�a8U��jW#�gPi�2��(��Dv�Ai[���6YX�������OC���k�u­�U�*����)~��e�����]�E������V[���%�1�/�����
��Ik�����z�z�O��1E����4�B��u�]��Be�u��ݮROw���Q��Ks�"��5��u1#�z��ｙ'��4?0���_��c�Ac@�4ԉ��T��ly
�d<Lbe�򕺃6Ą�Y�������Ρ~bß$ڝ�"���8�@a�����:��\��E�������@�N�cjD�ɋ�w3�Z)
+~�}�����_["��֞.����f��ĭ���/B6�E�LZ���ٕ%܇Y��ç�R8�Cz4z�$y��Yx ��<���U\�L���/(��v H~��ӌ���ؗ͝�<��6�'�q�QI�%!�o�=�ș���`��ӷ��>v�L�`zH��J���$�E\�[���j�1Ƞ����wYz�j���"�O[�v+q�(N(�{���4�X��!�^�o�_A���E������
�v:5x�w�1�	1�����ZV|��L�l�˙���nU��ɓ3\��m���PgL����*�ն <�����	�w�~�7EO�~2?��"E�C`d���zpT�ʋ�/�̷�K�u:��K��c	_j�~C�T�� TY�dUf�"��o�<+��v�f��]��#���Oٛ£�V��X5��m�v:�F�~	�nT��YE]h���2gA�������*��]W���O���
�չ��3)9eAQ�:�Ř��9�e�
�4ON�,q}SYS!����nY�,q�Cxa�-�LdS��J��q��������?���w
��x7M�No��jlq���A���p}�(��lk,�ߠ��P��b�O"�H��j�&�\du���( oz�k��WU���}�O��v��ɒ�gvwR��%Ol�M��V����ʘ��������x�W�0E����A�UmOĠ��QR�!�K��1�����W��3>|G$�Tw`�u��aY�>�����?�:���B���c�_�#�<�N�������8�t�|���s6������ι����&�$�ۛ"Mx���n�Z��a�g�6����
�u'�t�[Y-Z�Xy!���и@�$���r��p��Ǜ˙5����N���6w�qS�P|,C�Lk��&w�z��1hY��"��{	U�K�<�w��=��3
CDH��	u�L��^$���M�5q9Z�'8����P��_��wus��$]�1t�����~��⫕	�jt��:�C�sWx�	�'A=������$9��*��kծ⤪����&�6�-rmD�R�~�K��!��d2,��������Y� 2   3�l���	o��8���$�X�#5ϠY�a���������]R�      �   �  x����r�J �5>�/�T�а��
�Q���q�3������	'.$I�hU/��������gt����j3��TPH^ ~%�}���'���B���ˎ���<A��@a��TR *�%l9�t[����[�(.��#<��%H��*�N,����`�rC�x~��B%�QA 5��E�]+���u���;F\�/g��6O�Im���펣���ɣ�Gʾ�$FU�8����ljΗa�QR�X�����6���t��������,��D4o��O�U��P�P�/��3B�H-�:�z���t�p�	�H��}���`���)T(M�fj��|	%u�K.���G{&��J�s�v���Es��M&@�I�ߟa�H�A
X��;��������q��P(�?_�� 0+���E��qd8B=_�w�Yބ�([U��ٴ�+��S��F��lڙ��F4�@�
*($o���9�ޗ3(�~Ü����!�яK������
(���'��Җl�{[���uQ)��sZ��3Iԓ]ڜ�A�g�\D�f�RȈ���kw��Mn��d�]P����3��)���q�1�遷2�ƈ�R��� =���B��.I��\��@m�^�0�\7/� S�o�RQ��954x�:l�z�.�!��)����nc���t���� �o(�!0�ǆ�P�l�f�����|H66C�Ã#��9z��:@�s�) ����ߢ��F!6o���^C��}�@�m5Yt7����*�G'������^�IO��h��yh5���_E"W� ��w�URR�w�~��ܼ@����h�qA���f9�ݨyƘ^��洕���I����y]Dk'�5���/�~C���y���[I�h�p4����.�:ȳ䨛�j�&�^D"����`��m�_ճ��-��g�6�\�o$��z\X'}f��V�S.��0�2��s�R�G��d      u   �  x�u�˒�H���O��	(@��(�ܽ�lJ�U�M��������sb��@�,���3��os�]��+
�`[��E�R�%@�B_�����
! ���/���CN���d*��o�d�(s�tS3�ڷ!�W1�>͠ ̲�T��}�'�`<Yd�8��``E���_�C��-M}CY�ܪl��/	p
ay����]�,:�wz�u�yi�/�
lQ�bꈇ���MR�{�`�n�7�^�
��	�Gi�U��4����������EϺ<
���1�3��O&�>�&���P/��QD�����LO��1ZF��re~��,�/����L��?X�;Bn����4·��'��&��#��m!���K i
EV���0�Ƙ�� uG2�h2�I��<�q��a�:W]����)�B��N2�f���V�~-��񫓏3Wf��y�_��{�d�D~�bL�V�s����=xH0�nEٝ����*ڼĐ���Wl/2Ǚ����IѣI07�z��{Յ�y���7`�ᘅn�2�����pB�e����� ������Ւa�`K#�W�yt,���0,��Z���gF�
X�+��a��C�[9/�єWX�V��4�A��PN{e�.�uPU�� �����T i�@CfEwA��[k%u��=U Z�K>�����;u^��g�g/�I���o�K\/o뱺I?=��.)���m1{�*��R���T{>�.3�)��]ӫ�{A��v���Rԡ��u����%9��0މ�R�_����/r�"�,��m�Mm�5���ӑ�G`k+���\D�d�0�p��M�_bm]�E~,�u�i�/���D=5�������
�K���Ku=��j/m��r>�{ĩ�����\���yE�pwvxc�@�Gj8j��{��6ŵ����<G!�f�Yh�s�LU��«ƪ��\Fvy[��@�Ą�x�r�߷�S�y�����P:�d�e�r����	>%;7�V��{��ϧ���z�]�h�_[_��Lr9k�0��>w��J���G��Z�\y�4e��Ҫ��׻�.T�E�;��!�t�:T��&9���v����j����e�L�G���,�դ�y��`f{����⏓��Jes2s�>��l(r�8���x�}�'�+��?�����_ooo� �]      v      x���ǲ�Ȓ6��y���c67/	�� �!H�h�B<��<Yu���g����U�Y}Fxx��B9E!�X�Ie-�A�3�b��(
���*���������W�T`����E���R�� �C�ܑ��_��?������P�?v;������_���e�N��a�)Mݽ�^u`y�#뿨��¯k:e�������=�s�|����~�f�i�8�D�JQ4��D�]:؆�ua��!�`�!��s&N�����´�a�դm8�Vf>F4r�`�-ԻK�l�'��/:*�<�k�:Nյ�o�����i��ɲ8v®�{p�3e�\$�t�8�eܗK�d�s\*�1]tL焧���9O���ךSC�u0؍������]���.�����8����K/���0$f������\I�v������Z����-�8]Hp�c����37.�%�oo�ګ`�����I,��:�z^�T�U�s�&2(�N��Ħ� U�B��NxS[�_�9U^�Ť^�Pgst�K}(���,�Q���Nnq!ݵ�	P��A}���pc��&���| ��/#�©�<H<V=!q_8b�질���g>�&���F����-EsT���/�TLp��Wwu���A�QH��p��\n����|�����S�ex5��`ײ6��m1���O���`�}���I���,h���=5�_�=�RO�@�v?1(-Xm�1(�Wa1vt~X
�zie��v��4�Myp�,��>w�g�I���Ė��Ȫ^ZMPLr�."b�dw���ٹuз��(^�A�u���H�R8��p���	������ؿo�>�a�����)���v�O�F����\���|�����K����_� 3()e��|�'�vG�,uP�����X�z~zG��^W��L��8�D �]2[���f�^�P/�>��C�� }Y1���C��V� fL``kO�ҳ�'\-�����T�����Z4{���D��b�+�T~�֛��l��6ݕg�Љ�7�O�F��P�&{T���3�3s�������}F��z+�}&���(,2\j��/m��=���GN�l�G��Y(��$��*]�s%���Y�T�Tu�p������(��ˎy��_��VfPޖ����pb9����m1�F[��.�^~m�%v>��L��A<n��y�*A���iK�1�l|����o�����V��}(��4g@�͸��e�P>E#p���v�^w��6��C�]��颃*w/=�S���^5�_T	�������ϭ-��=�ey��\!�i�^����+��>���]C]^��y|H2�5�s�����l�
N�b���/�&sϷ�eWe=���V]7і��"�6���a�ݏ׀ۍ@�e��=X[&*�l���%[ؽ@���]�X-].��3*h�/�������R�;�a<�u�=w�!�s��{�I&��e�Կ���[~O<]Y�S�7� �S��(ffI���i}�!m���M(��~�����	:<�����{\����p�����&j�S|r́��t��پߐ�C0�e��d/����8���I�-~�7�� �|�%Ԓ���׃��*}���0�rBW�)۴.o*c��i����E�n
�|����YVM�H}@��-��E#�m�Y^l���9�<�zt�N{�:��[[l�V��܊猎 ;li\O��VU�z�))Lg:�o�M���*?�_�����������Ѭ��~q���i��p��n@�R}����楍�p9&�������i#;�;ܗ�e�؞ݺ���6�_L��a:�PF>�3aѽ��8kR݁�ф:�nl~x;�3����0���3��49�Kb��w{i��uȷ���>��udFkV�5��|v3��3X��s1%1�?��F�i�/�/�����ӪS����Ԃ���]�����uo��G<c(��߸�v��'�:�4�x��M��]�{@�z�56JS���.������i�2��^�#+0��>��5�]���x������'�����o�j��[C�9�Y���X��\vL�%K{�{�~L��N,vZǈ��L�	�� �o^�j�̥%s'��J���^���Q2�(+�/��A�_�#�S�;vg�)9�	0]Wܭ���f[���:���H���+j͈sq�-��(IU�!6������qR�gǜM{a����][֔b�����l��p��P=���4^�=#"�����tg&�Y�Eg��A��A�/D|��~�y���7?���?]48�G�"��"u-��"��){����8ž�f���bE\�߁�ǭ�G{ �|�9m����s�7�P��H����?��o+�x]�T��V[� ��aoG���X#@����it<H����&�z��[�)⩛R���SU��D�&����[�n����D��]>���[��,rKf��-�@m���/@�VG�=�e� ���0�=_�����Ğ��D��^vv>�>�K82d�-�h�W+�������(��Q�Rѵ;L�*P��ӭ��	��V]�Ox��W4�\c��*��{�:{������2 ��(Be�nd['�K��5��
������b�ظ��]��Jt䙻����r�d���L�=G�M譭�	ŧ�����x}����s�zj�T�G�0i�?�9-�Y[���B��a�B\�{�"g��mh�����ˡS�a|F��7�f�dH����i��3��C[���_��<����qD����������$�vs$�ƴq����_db�_���M���IB�)�b��᧠���pǪM��L��� ���t�՜��+W6�[K�x�"��V���&�S�*�+4���=��L�
�p�z�hE4���,nx?:D��|W�:\^�R�n�&���O�O��m�����QW1��\e�'F{#��T���_ھC�c��0�̓�Y2�U G���N�����gXO{A
���IzI��]�z��%l��e ���r�cPO����~O=����p<������n��×�2l��%������;�eY=�����C
��ǌ��(�<^�m��~cP�W�ʗ�]��W��ӺEO7�K{��=��M�n�"]��?%=]��p���2�2^��i���l��tzD�WWC��wM�1 F���ZZ�ƾ���awU/�����A^��|8��$�ʠNl��5��
ϫ-�F#���l��
��� H�L�ux��Ũ���'l�[#��`XC��Υ-6y�\>�_lk�>ʾ�
8]	��{p����j�mь�f.�JMX�3z�������g!����"���85Ǡm	Ә^���¿���� e����Õ8Ű�@��<5��FQ���Amn�lN	����������p|w��荑�!�폜�#��{����o��G�ȷ��3p�Gry���]�y��l.P,�j�퓇���| KR,L����m�o�o̺?{K;x�1^b�k�����ڈt��\Qs�sy`�����V�K��xFܣ���ι�������ΐg���ɡ���9����Y�6�𘜉�V:���s% ��5SsK���`���xa���,k���8/����PG
�xs�}��By��[�C�s�3s?u��G�������jw���\唕 bd���N���>�\[FJ���:�w	�l:�2�f����;����0���=��,�Y�֍S�����ܩM���s{!_%],�ߕ}��gj��F����v[�
�μ*�����ʢ��)��H�OxZS���Y�t�=��ړ���Ȟ����?�/Ͻ�_� ����3>m&l�ަ����z/��Qوt�{�B����в�v���2�{46*�c�����
޹0�-7d��P��«ʙ�����E�>�p��S�"����]U�;t
�P\��v�C��S������K�F����T�<Q���`UŅ���$!�wΙ�6ke�cF'�]�XU��d�o�T��c�Q���z����F	��&����(�VH��    � v����f�1s�S ��g�d�ى��5�>����o��E�NӴ#�����,����*<:�Q�)o1T%�����ݯ�Ôt�z�	���z�u1t�9�c;�����:��z����j��,��IQ���ɻ5^V�ʃZwr$iM$7u����ӣ�N[��r����'ǋ�q�V��@�g��S�##��9-�cL�A��>�/a�^�iC�u��)q�[z�N����\ђ��w*���d�&�E��6��[����;u'�L.G�G1�w_�K�"r=߫�����}����pF@�B�\�ھ��U��Γ�SID����
��y~P���U##K���Y�PD�S	̮ﺸ�-=(Ck�#�[ͼZ; 41u�Śl����_B�MP����;M��mm1�:'o�x�7���Z`4~�>�������$�rM��_����R��އ�����[l�-<wkx�u����l(�J�W�Ϧ:�޿],���>HV�`�]$H�=�N�'38�FG�3j���j1]wf,{<{&M=�����5�%�.�d+M,�M��{P�10�,o�[�a�GH�����(� >O�+�K�ǌ�ɛA��l���7�H���NC�9��뽱P����uL��3w���Ii��$�������Ϸ��M���G�M.#G����C�7��z�{��f2s-n��NUVc����b�>��8�έͳ�{2.E+F�i<��C����>�%A��d"�7���+�Pᦂ���$���\dkI�놴3HΑ��<�<2�}-���f��l����>�.�)�BP��×���tliϻvq����,��LP���֜��ckw%�X��v_~�Ӿ�����H��FJc�ض���=VwAX�w��p3��b6���^U����!�.���O���C��z������j��װ��X�"���,SleIB�}�����S�Q�J,��x��L?���	��x6k�AN	wcͅ�~��~o|8Wb��ciS���y��2V���,��v��-�.R5#��98�8��u�<�,�ǹoV��x��xx��x��jÃ��L������>[_b�7Poݱ��Vv��U��@{��h�m�]�F�ʇ �� KryO�36�*�X������T�>x%f\1+�1u�C�d[t�����7�ˀ,(2��!8�C�$Ŕ~��S����*�cJ0�E���� ���P�Q��1�p����)��Ǝ�i�P�!��A�ɕde��~�v����˹P�U"��y��u3�1>��!��6������C���ߎdD����/����i+��.h֮��xkT�c�O?������Cl�'����\�/��
�����b���G�[q �����!F�l8�8��a�Q�m�f�� ��h��(��'�{-���9�J,I�L��uWA%Q�w�Y��7�In�#ح�hǇ�y%=M{��������q�g�7�J�[-1 �Or��v9��r6�%T`���i�Ӟ��y���Z�����8�-3��r'	��!��&C;����|��������g�&���*1���֋/�k��8���kSt��7�eOs�/���\%f��r�-��*dU�?eL�ୂ�˺\w��XN�{������"պ;{��\nX��l��K�1���MXfa�AEa1�$����.a��TXG�� ���?�p�WRCZ��n)�(?��>�6g�m�p${З�MX��:%����'.^"��4�w��Rշk_�Y�G��]��k���n�rmDNm�:� �ۙj=�]�9+�"#h�Gݟ�鴍��i��x�o�	B�n�N�Z~�n7p�F3@�N�G�{��%���j,so��LWq,0����O�mp��>1��zw�B�\�6��p׼���+�������j��K�1V���]FL�P��Μ��{}����n{4<��h*8Z$0� 2��5���*���j���oPQ����}�O�7�t�!����ӊt�֟I�x��B���n�>�8c�Z꥗�w|�7� ����gv&-^#@����>o�һaD���G/����9~��͔S~�����~A9�	�Ku�t7����	��ԭ�#�bU&�p����?	��̂�z���+��6weB�/*~q׉r)��+�I�n�ئ��˒��y���.��G�w�y��y7�i
8z�V_��`z~���1��L�"�z+bBGS�~A7�˝����I�y` ZQ�q%����#m������i�X}�%WX�@#��p0�)�X'���%�ۖfa�Jɩ�Z��1Bٶ�8�^;R�Ήf-#K1���q��O��U��������1vD
T���^��R����1���.�׆��QؑJ���\���n4��xe�'��+����KH�f%��^pк��Q�P�+��4������K;�v����3��\�z�fE���ңseaub����-��<�d��sPq���)��I��t堾?z��_������o6��m��?�p<^,9u(|`��z������X��Zb�Lg�"r�L�3��j2Ȧt�r�v�ee�0� �}+��vޅ�\�<x¸�Z=����8H铬��L���;�z���E`�n�P�|��(�bz�X
ڥ�ow�̀�MY%<�oɡ#[|:���r�bq7��n}�$C?t[�u�]p� �)�i��y������ͷW�hK�
1��!�"N/�`m��R�e&����/��P,�E߻�؀�z�ޘ�b��m.!3�Ę9�vS��lRp���)��IxY�
�3,��$]�h��Z�J�X�GK��g��cܻ'�WU^��5�a�6U�����r�Dv�c����E�U�ޛ����KD��8�
:��=�o�S˗�lG��}��1�t����qd*E��g�3�8�@mE!�e�K����%7�nXP�s��|��'~�	�]��,?�����uY�����s>Ge�8~@�f��FZ���$sR�[I|�[������f��p"RM
,��R� �� ��Q׵��lѫ��� d��+�_�N�]�T���~���y0���d~.�Ep�}-BU۳"��o=�0b^��l�]T���_�V'�?e:��d���#�8���^�q�7�(��_�&|�+v�ئ�y�I��X��߅�5�%,Rקs_<5���I���H$�4B�Dc��pp�ʰ�,Kx�������$8;�T���Ļ���~7��Y�z&��$�=��?�^�D�i���8Q�Ǭ�{����#!2�㛥�^�)�Y�r{�[WB�7�NX�:�D�yؘ@��n�ߜ��k�����D�W�ԁ`�ͥ���M�&�=�:�;bD�"�j�Ϝ���ˆ���2��έ���C\d�4]���bmɦ)����S6����p�����S;VX�ԽZ� l��
W���K�͋�pN̘(�4�wed]�q�m̑Dh�AY �ěٿ��e2v�粟�.��nr=�n���
xu����]�����5I��֟���,�HGn�1�����d��;o��^��<\�(8�.I>F��q~���X7U���Ǧ��_�M)��O���Gq�>�u���ޏPĴ�:�v�5*�^+�8(����e�/�b]�g��{�n���0|���!�ł��M$k�ά�6�B�tUM�]ױIV>-[�s�n��v����-�1�ry!�j�<x~�[8fH�UQ��»�N!Y���\D���[IH�,,a7��ɷ��{���Z�9x\�+K^�&� 	�����1�K%��y�#K��ɓ�ĦO�z��8��⌏�Â��[���U�����)�h,.��MQ��{�b����#��ީ�����������������rZ�{�ʧ�[��b��OUw�Q����b	�ת�.��DY�eՖ`�N<�%�x��fʀ�pJ_��5K���y?������*�g��)>'��^��j�o����4a�ޕ�Sēr����Q�w=���#���	�Só�"�C��?���!�'|�epը�뗛�}J�����[S餢4�e����B�5�&,�\L�    ��8��ɷv�)u�n��A��jb/{^�ДN�5��*��#Cl>��-�X}�t�c�3Ӟ]?� ��.�|�!~��k��w9ߟ��;��$���y� H�"���<�;k�����NS�1�#c��p��}��"�c�!4i�{����uQ�Fu�ȈZ@v�E0Բ��=��U�'����O���>�}��2�.5��@^�����D@r1��l�U������Y7ָa(Q������}�^�"�J��[cX�A���?�MQ/ZN'��\��}���V�sG��?�LI�R7Žs�����#�g'���ml�L�
��p��b��-��������(7��[�-���+7�� �&�ȳ����2o�r�����W2����6�?x�h"u_��zZH���e�cWN��s,i�ߍw��@S��"@N+OJql� �G}0�
:�<ÿ;N�o�¤*	l��:�����&r�T� �;�d���Ke��:��H��y�����\r~���տ9�,!�D�0۷����CG��E��e�����oJ�m�L�U<$FnOG2�q����0"��d|S��ոgY�ʗoxf�[��Tz��7,��p�:x%��h�M�������ɻ0GZt(�`��=��;P��H�\7R*�ρ���t;!��h�!��#H#���O�߳_T8�C\'����$���~��K�_|k&��P�L��T>h�;��7}�����E���tS���:~%j�/�i�������=��w�IT�}�ӿ�[����`]�m�q�)21��XI#wϸ�P��?�}O'R���*m@�Zɒ��{(h=s`�ȴ�����_J�#K��A���+�큯Jq)������M���x!��"M]��ϝ��D����U�ֆ�˻�]5�OW����9}=��PA)n{ln���{�}������nΈ�t�����)�]D���]aٝ]Ƭ���i`�Aٺ�׌�x����\�zO�S�d�1������	�e893���1���i�uj�-�����&ݳ[�:Mqӄ�{8�t���	�Q��	��J�dO?�GP9�^�o�!�r'�[��Y�uЂhlL1|E��g�銓z��8>]�r�g"�T�W���Y���V�]�!����]t#=��4���C�����$\��L�L���<H�
��o��l����\u9��9����W&�?NYc�C%-��t0�T��"�)��V|O�X���lYr
�٦Ѝ����0p��%N7�}�v��7���ѿ^-�B$9��s˟V�������ٚ�����88Y@�^�{�kDH���ڰ^�Kjߋ�S��T���c�I����2�(�a�4wP�=��~����H]�rA���G�'-�Q�G�P�ĺ���ɮﴉ��^�ڳ�N	֖)�U4��OQ�s���r4�����(C��)T�'�SH����C7��_���������MZ��q��O�1^��nGO����6�x��'��JS~�nT�N�k��F����([�U�N�YQ�O���������G�o�Y���wn>d�����zs�˹>Ev�Ȍ�J��T@��֎9%�C��jy�1��Q�z禬�T�i���>���˵��O :~��\�n8>����1�Έ|�[���)$l�Xm��L���73�F��[�jK��U�|:~GV/:�I$>2��ƺa%,N�"᎓���?�U�$�J(���(L���Y�_�F�1��^r?��?������&�d��xh�XFy[��b�j-~~��M^�Ǹ2���6��}�����4S�X�k�gD�?�?
z���Y.�+�ӽd��=5?HxMȘ�,�L=�;w��/��yE�O)ϕjj(;6�rY��3�Ļ�T��E{#䄃����C��y[���-v�_��N��*�3�6#�vk�Cd�$٦�'�[� {�Tg|����U�2����O?!A'�Dz+,����W+/����8�U[P7[#���[�$!6ժ�pu��W�>}W߇f��p���/_�o��
K1����D�L���
)g~��J�*���wޣ��O"���CD�84�A�yȤ\9'9M;�Ϳ{��2����M�?(���j	�;�v*&��R��m�}׌�B�����f�����࿾]op�|�h��2<q\C,$���[:D���'��K	�4Ƞ�.�vO�7��վx��J{�*4�7ĖCT>���)/!pYN&���TQRPz�����7}ˀ��I��S�M��ϥz�������N
C�NP�s���wSY�h��P��ǋR��r����!�^�i�4���'��翚��·xͺ�kZ��LK�a��1�����~n�wS�"���iްl�SĔ7���vcKZy���g�����?��F�_p˟W�N��92�Э�%����B��wu�<3�Vz���*����K
�/�,%�Wш�Q�B�{֍������,�K�}�^>З��<�n=�K",kg�K�L��x�4x!�]!r@�Ml�sHPQ�V[���NM�A�І��\W��\W
P��}��տ]��.�'��H��	�=u�Ο2�_z�B:sa�����P�+�	�#��e�U�p�3�m#��0X�vK�{v�K�M@����'L�V�5f��WN:��DԞ��ٮH�����T�W��靶�<�>���d4����R`?s"hݑ*q��`�D���lv��x=�鎭�� �8N>7:��,rR_��K��rV�����鼋jBB0�,���7��GYS�s1�y(v��<C�n�}+���o��WLZ�[>@�}���5
�mF�\F�̹�t+�ؿ�ʤ�5>ژsl�DO'~R�"��m�_��N}���S��l|�y�Veς]���(�=O��3oݸ�����m��߶��jT~���NqB9�O�'������W(�t��3W2�ټ\$���e�[����>�XYJ����|¿��B"׀��;ZVQ�.1�!�Z%Ȼ2 �7I����ڧB}�=��e\k���m�l��=��Π�2�y�� &���K�����CǖF���N ]�e\M�1��hx5� \�>q6.��W�_s�����EA�u�����-��3�ג��`�oޑ�W�;b���. xq�r��Wn�%S��h� 83s;ܪ��������*�c��F�(�����@���9�F�O]��F��>�i����N�~���A��'���D&�'c�r��^���motc:6��aZz��O�f���s�q׸^}�f�+xi$fu{[�'K�|K;S�����KBګ8��lxy����{3LE��5�F���p��wo�2>՗�	JϨ�����`���8 ��k\0��p�?�w�9�&?퉁�Mu�:���&�b�a���!j4��G���~���K��N�z��0���G��Z�QrK,�ٱS�`�B�zX��Z��=l���A4n�'~�k�a�^W�F[�L؆�<Tp�g���,7���C������B&�;�
���Ƭ�~�B
�:}>\�[��I�N.���N�LA�7~�߬4ܝ�!�0s���)���b% �hwZR�6�D%l��6��e�9���ۀm	�j�mZlO��`'�߯�0Ȗ��Ȓ��\HX�����a��Z�V풅ޚ��;�w�yBOIIr�����!ӵ#��ƫ)5�K�Ƭ��y�� �����x����@�Ӿ�8��}��5n�щ��Lw�di�S^*kJ�DŇ^x]u� .�;�~��~�'�S6?=F�hL��m��V5X�s[2i�:�P^�W4q'��Kܘ�Ad�*�TG�̼�?��L��[��%����P�Y�Ҵz�j�6��-B���X5y~�y�}�����۰�%)F-�]|�@~���[��){����D��B�ge��;u�a�w�l�\"��C�����} �['�-���f ��a�8����7�����]�咨L�Fw���)��;!*���q
1xm�ֈ��lӃ���.r\.�_Erxc�O`�IA���}*���ryE���;Ut�;w/�    ��pi.������)�?@�
�G8��@�(��t��Ga|��r��28z��2ýQy���gu Ń����1J�+z<��%
|�ϑsTދ��ʼf��ޗ� �ہ!�������8=�h���r�s,�QMK�u}u����]f�1��Y�ݭ>�߳T�+ل�q�F�$Yi�@}����]��p����1�w�@�������$p-5���٭*��*���a��Z�=?�{`z}睓{J/����5��UF�ʂ�sB��������6�bO���}n��<n��)���=B	�� ߖ�Y��(vW�p��oZwR��i :[�:/��;i=�L���_��s%��Zm�E�ӈyv�����]���b��{4KT@6�����U��š`G�W�ؑ�Fc��Ԧ�wwz���rs&�U2���"��B�cW������EAd���"*�N auSPǞ��%���#W�����{��{�Tc��a	��T[Y)��p��{dٻ�H�^0r��x!6�
,<�	H4'�j�Ѷ[�ߍʿ��˅M�K�6�d+_^��C| 6����h�;��d��J��Y�]
��M�E]'s���o?.��l�I�y�A�GOA�e���\U��ya9=b\(���A�t�v��iB��z��S9�xz��&\V쪇%�9̼�*}�kS��~?�������w���ܯ�"��|��U����o���bo��pԋ�Xk�K��Dw|V̽�(���Y��ˋ�Av�F�����T���@�����~��K��襋X�ו��qo��l������=<��٩�)�ݵ�;�c���֫���#�x�_����2d����-S�ڳ^/����2�5��b��9�>3��+��X�[=Y57���U����@4O�P��ms�;uo��
'o��v�'�i�B9v���s-�,��rv��,����$y(/
�ٍT�N�� ���K�1ͩ���+�R�+f�}�l�	��	���n��.��N酨���o�L*������g�(�7�mj�T�ROvK��2�*?K�/�#3q��w7�?hj�T>'T�Z������Q�
i'[V�����K��ʃ�^�pC|�J�ؼ�և��6p{�lQ�T@=����}`?��yup� ;�\j��r/�f*_u��x�ޜF:u���=3�'�lmU䲈y����(���ח�7a�0���C㹼Qj8\|�\��m��4`����:��Ӷ�]l\�?��������B����
�3�q��y�|�v����p|Ew�N<-�����
|+j��X����5|%�C�N�lyF��e�N!��Uc��n��/����1�������Y�>��^V4#��bTjY��au�2��>�����*���`՞����+��}�?v�(?�����!�m%�������oԩ�n����G����e�����c��;7��"�������;�^�g�o����7���	�"�$T��i��Lg����ɫ�������2�>'XV9V̈V�����=u��~��.P�_L�d#��vX�p9)��z}�NǑ冤��A�^���e_�F�W����b�ӈ��2F�@>����F�G���	i5x��l�O��%F���^#�K���� _����p��71|0�)�w�����l��<�[��
���~@��NC;nP��B����E�0�9w�}ޡ���b��{�-.N��� /�B)P7�Y��J�����7����ijֺU�C*m�d�>��Ӕ���{
��`�^$Ѷ�]�]�e�Uq���2U���-���=#~�t�;���q�rƙ�An�����t2��*�G�6~����k�w�O���?0�y�\����󂖍0u���a�5Ǿ��oɋ�h|�~G���6�{�Kesi��qSd��V)��:����"!wga}�,��W3
8"��p3Z��k�F��w�Ԍ��8���Z����D�/�d��~�����.ׁU�e��j��o����ڌ����v�ûx�Ղⷘ��)�P\�1��6n~-�Ƀ�A��q��o�^l_3P�$�r���a�������x�Վ�������]��J����QX�ǒ����%�fE�k����%d��%O6!=b��#�=���)B����]� /�{�Yةҍ�����C���p���V���9����� �gEL��N?����'�ܫ��.�}:�"�s/J�-!M6�����r���rT6�j�ӡ`J{8� �-,��[�vNvw�A&�g�?M�Ii��?�%X���wH˶Sf��} �s
��>��$��e,E{N}�	n�T��� QZO����V}�'�C��y�5j;�+ߩ��8��A�4�8���_�,(5���J�k�k���w�FA�uF���aͳ���HW!ȳ��z��6�;n*�w��+\�7۟�}'?<�ެ��q��r����9��Ly��S��+�ڒݽ�xt���s�����Zd��A *�z�'��6������Bv��_zV̾kt�i{��PA�.��\�2��t�U���oJ�=�je�q�Ю��[#�'p>��T���+�M�_`M#6*j���/G�u�RK�N+�Cy���$����y}���%vf8m7U *at/�r�K]]��� Y������(����9�����7# ]dG�a�GD6���_A����7#D����gH=�{��pυ�B��ع�O4ؼ#�\��4]�f6��Z���Լ;F���<]�τ�Ur��B-p%��D�1��$>�|x�5��}��B$�m15��� �/Ct`�*�{�S��� =�©���3���W�=�*�����u���Y�@������؇s��r�Q����f���,�޺���|��!���qK؎s՗��N�{Η����q����|�Z&����0��`]}��W�c�����沶�2k�������:F��ʽ��iyb��w�c���Z�HmN� ̞O˻�>�9��wVȔ��-+*�*��S�ҁ�������"V�~�/���Wx������{&��3Ҫ �Z�U�!��^�3g��u�?ƍ��K[��m���Wڕ�8�,��<���yi�ְ����j�6F�f5�Ylï��UsG��Vˍ�I��d��"��.�aq�`ϋ��ޮ���nsg�%xy�?Ն�o�������(\����(9����E�5�-O����r� h�A�
B�q�%�*���2�WZv����3��w���Gt�	��2�R��'B��ElG�U��o�&�n��N���������Tz�����N�5�����%��ǫs�+��c�u�������oY�)�^n<��$�m�E�en�c����hUV� ���x��FC!@���g�G4����w��=�VU�nq��2l�
	���<�sO?`J�0_gUS����6��ڡ!�ڀ�
��R���I��h2��*u�}(�a5�$`��i�4R'G5��K*^jש�Y��ps������p�->��w�Px1�@�(R��I&�n=�y�_H�֞������p	�O{�ߘ��P��ʩ��&�(�Һ��Ö#����ν:3LOG��3	�|X��l���֮C~F�G����L@Hע���@�����h�����r�\�s�m-ܣd7=xp��Qdې���g�<ĤQP�<�6�x�ӱZ��y�S���������3������<̇iXV��m��G���Ѭ�J:8��:�;rDh�	�7�|�|�ӨӒ��wܑ*���lOuw��R�E�3��֯�����R[I�lќ�>1x���r���t���´��}"�z~\�@vr���$�M(*����)���3�������Sf��>H��y6ȩ��<M�]�r���SC�J���z��=x\�L��C�R�į$U���D~O���Im#��nޔm���m��	;�0�+?��Z�N��q�V��ތ�^h��Ӊ��|ݻu�Z�k�q������K��cw�2@}�x�g    ]mV��Q���<o`0�1;ejӒ��U�~�񾬩�c�)�Iu輯x��z��=�[ ��XEF'.�1�����=[��q��h�����$ ��[�Gt<^�`z�,ര�B���dU� �`�lHu6�#vlx�{�^�)FEV����A��'�ϰ��m�aϪ�ý�������<�Y��'��*��ȷ-a1�.vo��̡�cҕ�A��8��䡑���W�ףX��}n]tw���+�_���<S9�*�g{X_���l]�g[6���=6��zHy����7+���ϑ˺bň�j�,4��O`Z6?�=.%wխ�GfӞ��u�9:�#;�O���Q@O�*Z2�:������-ư��uˉ��?��2��5@����t�v������@�8��ٞSN�4d�⋥�	��,=�;0�e�n�y��-�6�����p���s[�i
n��?\N�� :��2:�b�3�olT|���N<	m�[q�bA��Z��5�z���⇮��(���#r94*E(jcM+�tn��n9����)8�~��(���;x���o�[1rG��	�����gd�����&fE1G)�|���E?�$;��d�������Snp�^�;EL}m蟙�o��-�6�������h+~�.T��}9�A�`I��rݪ?e��}|�������Vڞ\���h��&7�\�D�?�>��q�N�%�_עQ�I�õ�������[~��w��Շ�n�MgZVy�s`~�c��o��e���Fh������=sl���6 �з��o3�~�1��(j����P�통�~2���FG�����Fc���n1����,Hw>��-��!2�3�����iǳ��m��t�_�Jgc�Q[�R�w؄v@Ȫ�,+�jEw��+�Ŏ���9�`�+��t�I��%ud<t韩{���DɺY07�mǾ9�,�N��6�}l��ps���j���%�Q�W���0�_*���q�P���
���g��3u�'���;{X�Mrβ}��-.�-|]K���HD�Upt�H���j���Q�`֯R��i�m�]Ѓ��w�ߑt��^�Z�V�2��6�8EM�@���AJ��l�4���L��Q����.MtD�P��,�F��[�D�c,z��]��U���e��q>��|S;�GH���!�Y�;���3b�hu�(o7�Ϲ�34����5u_�km�5#������ij���~::�޲s����k%��]�݂΀�%� ��&�����n:��W��J\�V�������- 6^�8�.��u�d���m�����-��fC?�~�k���'��	�(��lW6��7A�cUe`���?�$vvG�H'�UT�����1Z��f5���N^D���[y! S�^��h���g�*vĎ����SY���a�������;<���[~WR���$�e��#q��{�C@���Q}{ф��ED��=�9�k�i(�l��a�^]�!i���+qz7R3�m�ܞ �w��Q�ZF�p����xa��������G�F�ࣀ���tms��16
^3=����xU�����4��U�(>1x͟�����=��i�y���"@�~�z��Y"�L�,�7�$��S�ãXzW�P�������~��QS��~*F��1���֜��rXנ��[Y�`[��ء	�Ct4:J\엙\��ZC��{��p�Jٜҁog�9n�=�y|}{]�~�;��(C����>1x��ti��C���@����,��8�u�~���%/^��|�z�zh��L�I 05�=��Rί���8yhWy�9�e�qr�Vx�嶿����tm�y��CVW��:�1�l#W7ʉ%��Ο8�u<o+�RkR�%3�'� &��rtR/���4�$b���:zaz�JH�и-L��n�Ω�?-S�_�Z��}˸X\���9x1&@�K'��.���4㭲����B�X6��,���i�|��c@�KQ��tf���ޭ'��C��VS�k'��+C�ӎ>y�*34�
"Y������핗��@;��N��zŋ�f׉Ɓs�����۶o��O�B���T���X���/� ��.K���f�,�����O��>޶ޱR��v_e�kQQmW����z��%n�����;�����uW����6v�sZ�.����W�oD�;���}Q�I��x1��'�ˁ�:)n����p�ѹ��HՂ"RJeƮ?�2�ˈ�5��2D���$R+�C�݄��Da��)`�K�/�WY�h���ni�@K������t�
���#]�;x�äl��~�d5��^��sٝ�+:��.���n�Drj[@��+�c�^�vP
����D	P����|����3�ՃeIJ�4��<�7��V&*�ȡȠ�ؒ�������U��p$�/<�Ը�n	��wp/�c�s\<ȓ�/!��/�������G�5���'��$��Q�o�i-8%�Z*]����L�K���v��T�x"O�����ߐ嫶і73�yr���ֱM���	t��k��ěuT�pLc�ʘ�$�%�Yk���[�W�z��L_�)\�H�Jk�d{ԧ4�j�g%���3X��܎~Û�~ױ��:�^��t���� '�|T������l�9�BN�Gށg�ǩl/�C�:�尭M7b�;�"<<�̤r��Q�3��u�*�\�[��F\$V�����~��:i���Û�-�.���龿B���m
&�#Piץ�c�C�ok����=���eD��:��.���_�p�n�
&_Ey��o�>?���ه�<) �����}��@̦�;�_��M?y��HB���z�H���!�Jރ׀�U(�Ζ)��ļJ~�����w��a_":,�.4<�6⼄��s!�g�`F��DDj����u��k9$�{+ *ۗ���U�sM�^�*�u�xs�����L�t�(+��x$'��H�#�t���s٫d�3�)��F�Cj�]�"�1Q�;af�Ş��צh|l�������
��y<PXY��r���˥�m�L	��l��c�� ezMΪ�3�@���^ �9mD��{Ϣ��<HPl���n�DH�0�,�_폓��� ��@��Px�ۓ�4+��-��q�Nf�+���~t�\�\j��s��3���U>�%aO�[�	�t�}���E��FI3o�ʻe^'�&l6qVl���6�sL��w6��e+)��q�q�Y�ܛPuπY�Hq��0�p�|����5�&������֤ё��f;�� �;���[���=�M��#6H@f2���(�����2���f-��1O��(��'؟X���z];|�T�o[��3���VP>sj��[+�����Z;�DTt�%�bR\o��,�no��w+/��"H내��P�O�gnneV�M����-�v� �*�(��j�����4X��t��"�O�\�K��qy@�d5�����P��1fAl\-=x�x,������
�'��5���i�~�K �I����?n��(�%�@ƻ�̪�i��47*�E�vT�jyQ2�x�'��ľ&;�uod�3�׃���e{�7��8y<;�Ʋi^�9�I��B�o�H��\�9>N�����+Y�m��7�C�D�/S�r�Z�^��(�ż��BL��rq���������B���i`����Zh�T������tӤv��v�(�o��4�{��_�BK�������à����,����7��u@�11L��̞�����~�-�f�{�y�����>ᯤ��4;w�x߃pY���*���L�3iEw�2��`�Oe��kq0�������'팥b�:Yƍ�E֣f�@��P����k�'� ��E��L�s���S��$��i/�ZK�A,69Dxx�[��:�t`qB�	O~F��J�����_y��M1tE>5��7�I���������7���Y�o�?e���ߚ�,�X>ͲH��0�;�Gni���wR�W���n,�O�%(�E�*2�J�W�l�h�������'��v'����-#��Ʊ�Z9�F�b����lL f  y�2�=c���hF2AWտ��*������.G�������k	⩱�����ݦEΜ�G���E��j��,~�P��?�Ǜ����*Ɏ�����x��N�����%���hn}Ħ��+���[��³���R��y����m%B�A���Tx�������I�hU��p��7�㍙�i��ķ�.���_.�w����ԗ���G֛�*Y����W��Q��]N8H^�9�e�Y�o��#���=�hL]aUF�������zv����8߇0�6SD��fy�ƍjbqJzZ����pc�l��|�rV��\9g!�1Y��%����C�D����Cԯt����gE�Ծ�	�u����c�	�å�r��lk?|>*�y��X�U_?,����C�<��!?�Uل�4d�v�����w���������_�'B~)!U(R=�O�˪��;�:��6��b�8����_�߷٣��a@0E���@F�����Q?1������`7����'G���~��[�<��GA��3l_�+����*�C�������J
 ���7�����&��l�M��=��?���c��s�Ȣ�(�|��,������o�����      w      x�����F�.|��BU_�ˮϋ�P�"B�T��"� @G�m����d7�Bh�~���C?-?��z�Ձ�X�{�؝h� 9m)����F�:�� �����b�v��v��n��uп�>�XzR��ҞF���7��KW�AO�C7;�&�8��a���.����C:��y���/��H�����)R�ؚ�rr쪼�N�?��*�bT]k��?� ���i���
D������(�޷��Z@�Dk��A�*�a%d�[�4:-�E�Z��Hw��a=��B���K�:w��{�hI�(1��Z�&JH7v�gg߱|a�� �,iM��]B����x4�g:�o��eI;FR�C��,mˎ�i�5��ι�%5�79o���\�`�X��h��{�>���~�r&-Km�A�ED���wRCo��J䅜�Bɶ��B�)q�b��v �1�{}́8=m�Mjˬ�����*A���C�%�]Z#%ʕH�	N{�oNCw�{��&���^q��,�6q`r�{��'�h����l!��C�pSp��JD�%�He�fN�֐|a�<�&����Y>H]�lH8!"��:'�!�OZ#�&�	���0��6��&�a�!�0�ŏ�����h��D�rX�.S��q褀+p�^�'���I����xD�e�a:�ҚN�?�]%$�|� �Abc{�h�X�[Tl$��3iy���Ğ�q�O��+��Q(A�3�ϱ�-�}!�ڷ%xm�K5�Pb�d��_��� �q�����"��)VG�PeM^�$B�vk�:�f��B��n��F�Eq�E�h]p9Bx-�*�HS��3ki(r�hy�'ONZ��F:�X�}#H�N��h����mԸ��%���+����k����)�"���>�9���g&.�|���)�"w�3��������˲���p�1hU�'# F�s��P�v/u��q�an)	`+�@�M�r�YD���n�9ik��Y�����*}���ı���Bнɘr�L'���	xi�FJбg�f.q���i�\)���|���5>FV!�y��\X�3��|Bp�YW����l��I�i�;���t�K/h�Ĉ��˰r��"�M�ưE���b'1>8[ݜ�-��q��k�[Z޺��j� +j疯���6�z�o�+G6PRP�����/�y��?���E�Wf#7��\�"D����&E����C�2ԁ���>U,��|�༼\%D+b?R�0Bf%a�*-6S
Gy��	��>���2��>#�C�PU��G������t�4�A�#����WU�}�|BP"B�b�r������:�Z����*���2�a8�.L����2q�)j�x�b�m�&��C}Z�$���Γ�f��sэo)(b�ȹ�҆�PC��t�UZzh�,��@#
7*x|�V�g^���f(�0�|�$�RP��`�`�������ۀ*1�K �������I=�^�Qe�qX�%083y�;��P��ǵ�!BT�Jj��>"6M ��p<�;i!	}��%�D��&�7��	��0��>1�(1���}mڷ�Q�;�(m��M�΃�Z�������f��踲|�g~-��	���qO
�+'���PUp΁
���4{y�&���ݶ�;��&���I���K�����u9��{$����!Di$��ʱ��q{�E�!J8�+T�"9_o��!��������pJ�ͅfJ�l�	��0T;8{4@nm#��m�G�Q(A�O��r�Qs��^��*x��#�{��N���n|:h���5�9Yi��ۮ(V��[s{�0(!����P�Le�' a�<	�� �MU�r&���h��������T�k�)���;�ŵ���w����B���n��^w�N��2�Yy�@k�����1`$M�v��/���~��A�qӡ;c\�8�����s4��	.T��w�m_3#a��� 58lǎ��m��õ�%lHL�ݵ(�;��í��]!4�p�с�\�ALK#�w�3I�Ѿ���ƓYq^��|���_��]-��=���|�h�SY��.�\h��j����^46�bP���p|�SFPE�oB>1�7��,��]�h>FF��O�RPĳCy�W;��Fě���5+шzn�V���<qLU�x�/�~M�B�-N8�j~���`�J�'�y�O?�>\ ~�jv�ܙv��̬��XO�����T���ΰG�p�.�5 J��y��$�h�i��tQjst?EF^fԇ�''���֖�mQZs�<�Ӛ��=nuD)������y�#�P/k��������Đ�il�@��Hy���Y-_m��e^�|lU�Xa����/�,�(���to$����u�(�T�*
�4�T7gZ�:��g,I�>�Όk~T�Q�zR�cM �͌�zt�L��K����MUl�x߿΄�W|/'�8E���X�������2��%Е�ݓ7}w1�B*����K�M]���z=�t�L����p�'7)����J��i��:}o�Ȇ�h��"�XHm�X�,.$~�p&�:�{>��������z�����p^���?'	��50�&�C����?���X���dN?�5����]Pgx�O��R�lv:����f�f��P�l�����v�y�YҀ�ڻk��[*���8R��bXEQ��_q�I�<g*�K�Bܦ@�V�{;�e�Rp�T�G�t���ݩH/S�<�08�4uN������	!c�ag�>�E7����[��v:��������Ͽ�[����?�g���D7�Z�n��,�Տ₵���*�R����>�Y�B��ս?��Ϡ����ay6�d��N�~�q{��p+9�O��Nݝ&Q�Z�ZJ�|P�̂��t���4�1Њ�@���M���7��7oe���QL�-�e�zF�>(zs���8jE��Y�۵��(\�e�t�A��wTYE(ջ&�'(s���%��s@�<�+�J��O�y�9Czع�O�$��Wz�	��#72M o���'-k)�9�䬭|N��6k��j}�b*��ͩ�e&����Sw�MH�Qcn/bǲ���P<����)��pt> �HAfJ�e���l�����h��/i��9Ľr�{���*Π��!�����,�xw#�׹P�)yX���y�h�0�u���fn�P�@�Z�m���w�U[q��5�P��\$�>�x8ʼ.#�_��6��9;�0���^�$U��G�}ɀw`H����-�+{z�]�	<vD]%5`PBВ2б>[�
ϟn�B�y��n�7apoP��z�饹dʉjV�'% 8FB_a�SD�r�P��ROC��s9�/�Ewז�k��uoϠc=i����V:υ�Z�7w���[�@����I����씇� 0�J��(���U�BC>"����Ӡ�ru٢���a�l'�}��
�C^l��ݯ�P��s�țL�u��hy��p�����e@�#b�T,�� ��fze�����{\!��Z$�ɏ)�~Y��މ"#�'�����0_���Ɓ~Dh�~nXxK��SS��/�T�V������ �<��+�g�p�z
B�i�*#E�X���g�t�}y8n�hx�aj?�r%";'.�	$%.����1�2����3��{�V�d-q�x�����q����I�:�`�H� N��_�1�չ_���%����T��HD��|BP"��!�v�Yf8�V�_V���7.P�|���>$����vY\wX�9.��k��-rpb2�r^���3�=J y�Ǔ��X�	#-zW�w������l��rT�g�9��U
�S�'
9�Q���SU���Yp�<WV�G�}�P���6�N��j����#tT�s�r�uM#7�p!$�9v��M��u������L��VK��ݢb��T3�Q(AR�YB�r4:��(j�h	�ŗý�ʹW�_f�9|�bd��Y��G����tS.�I,f�!�����$��	��i�g@�_�.�G    ;|!�?����)�QQU���p~���HwH�δ�yU����`���hiW/�r��sL���TN��N�l�dgn��W��~?��=Η^"u�G�ELq�z�V�5�	����#�/�7�ػ�z0RF�.-��k6�p�Ն���5��-�&F��CՌB	R�Q���]�o���6��'�h���B�i3����`4^��fn1bbu�O�1R�΃q��Cq|@p����'����z��|�����	���p4P���R�^�T�۠xP��.��g��Ӧ���9���g�IA���\�)np%�8�quc�OP�=yM��l6��0EO)�3=�|-���խBdLJ���$� :Gs��rj)8�j������C@&�jr�u��$�ȢG댚��I���z�yTJ���J���󶳙';��0֫�7	NF�V�M�n|J�p��ä+:T��s_VxK�iǵ��n	L9�Ba*�JO��' gg��I�&���}�U[(4� ��3.�o~U#�i[�-�P���y���x�"44="_/���,4d�x�ˆ�ZNG[sc��y�� W��Gy��f..�Mf�L��zo�)d��^��%*�bzp�S&AI����s	��J-����2���Ml~>-�,6v|��B%����O����g3{�_�r�=zA#
����b�2�Uh���;�}(4���23�Ny����;B����{��t}�=\����\�s>��G�5�P�Dynȁ+�h��,dzz5��f����"N3�cޞ��B:�9�xC�%:���6po�/8�0_b&+�tƆ�-:+d|�,�nQ�Z�K���~�Ϲ�P*.�Zx�-�Q(A����=�5j��ζ������<>%5�p����Rӵ������c6�!n ��l�-���J�rp�ƺ�yqï��L�D���lg�>?�oě0������%.Џڒ9�8��=ue��������F�P�V]O���Sw�DXEu�������Cj{iC�/��� R��/귺�C�:����2�.�}p��9S�}�/0���3�BY���3�<���������\8�L�F9r�t�{�au�N|�U���u2�:�,IQCX#��0�D��H��U�J���:CX�W<���[�Q(Aۡw��6���PqM��lm`���#�f��ic�Ȏ:���C���;�}띤䶣gޟ��WP�t��k��t.l�x�.���6�;3�L\0b�ޒ� |;+�ag��6�A�E��j-�����3\���tg/��|(b��hJ���R6ap&@w������ %d�+u�-���}��ٽ$�O0@w�`'���͡���y����{�b@�Ѫ�3���������&[B��2񣋡�y5�}^ ��?���Q�-{�7�U�A&A�m��E����0Õ��c��d��T!�m� �4'�s�ط��N�Y��TUr��TK��j^�ijr�t�b:�܈�
� e�2�3�{?��Z�������@	��UB�������w��#�9�[[���C	S���M�>Sд���I���j�$��K&��^�gc�I�'�Uշ��U~ꋄ&n��5��q�� ���qۆrM��H�!N{�4/��J����AG����ӹ� ��	���4���=:Gw��ӹ��>�9��~��� ��\sK �0����'���@,��	lH2�����������)�|k+��0E�nke;��� �Ȥ��fb�v�f�L�';���!�)�.&��uΫ�n�LC�-�ݽ���&	5We?f�\�i�n���P�i;.�U)��ε2M.Jy��<A��6��:���V`�4�4{���\��C��Ҋ/{�~�0��>2�I�F����'U���P��JP�c>\D]�d����і^��lb��gZ��>N���Yb�:�Y�� 8�;۫�,�S�=����Y�N��,8�>I(IY��U~x�t����߬�3Χ��3��{�x������?dCF�T���i�lw"P{����U~��Z�e@�;������Ƈl��<��/7���7�(�������/�M�K�ȥ�k���n�~ρ*����7��5��G�-�����gĞ7�H9��4���N��Z���L�	���0J��+���
����k�禢>����f��Ug����ST:����tl7|��(jz���'ǲ/��'=���4C��ޭBᤒd��Rq߳�bNĉ���,����¹la}y��Χ���vg���d��Ӿ]�|כֿ \�sZw6�&�h����-�� A� �����F�c���em�c3
%����;0�4��
�����~���kܔxfy׌)|L�^�}ߤ���@�}-$��ԟ�5@t>+�~�⢞��V�l���%��{����V�rO-	���5��������g�3,TKA�sf�<W%���]c�|#�6]�v"�k��e�-�=>�x�Hl��s�S�^�'�\�x�u�˶�WPq����@	���G�gm�^�A8�5�}��	�$�qĚ�g�X1[��E����Q?K����������4]�R�����P���:��m�!�,3�W��;d~e�\k-	��9��$��1Ƣ \�)�7ss4������7�Mc0��&A(1�㾮3�|��+�cf/�YQ�_d�Uiᙰ��Fz
h��M���k �����q�ؖ�C&	2`L��u���F�逸�pRvQ��T���}��&n����t�\��=5^�(/���gN���V��}�;����@�+im�����������،��D���oi�Fo1嶕��|�3�o7-4@P"��9���R�Lg�ڳxߌӄ��j����(�0i��s����Ь�l�Z��f;��0rN���	���Y6Z��AO*�!���5��[4�PbV}�+���� ӟz����	�mF7~�;*s�r�Z�0�G}k��~� �=nL��x�ɼ�-��{p� �<��IJu�H0l������rhDᬪ�؜�df숮���`�+`�?F����kơ�Q��on��IC��pFu�����H�'����sJ�m��#�#
�v=�u�JH=E���ж��aal�s@�]$[O�U��3Тt1c������{j�(�uş�����M�ء�`(T#��n�ޝSo�v��d�-��6�r�#'�ݾ�p:v�a�d���t��������������2�˨kD�\b�pFьe��/�*ʪ��E�ߦ�yM�r��6���;xK0��0���Jl��DY�*W�����+I��s�S-E�y���S]~{Z������j���D��	�������b�B�L9gz�u��`�J/PƔ�tN����^�j�{Ŀ�p���o��V����^I�6�>C�N;�e�%=�G��FQմ��Ҕ�{ʩڋ����O��7p���jq�L�8�Ţ���~�jv���i��*3�3ò���T�6h��|��f�NapPi�yV���ч��p���=1�<�w�������yŠ��b2�ee��]j/��Ϫ��ǈ˷��/��\�|����ͅh,�`x�__l���%����q�����OX���ÎoF]3
%����3���>M�'�S�������N���Ǟ�_��F��VW?��[�-��t���:�q�J��H_V�/ք��A���v��)�Q��e��o/�����GZ�5�z#��.Ϗ��Rp:a��|IRD;읪�<���*N���R��)�?���\#n��_����-�D+9ͦ�(
_�z��������z��i��<�T���{/߲^�SHL�_ U�u��l����r�p2���d�Dqu�s}(6�p������I�DN׆(O��.���Rۿ�	T$�[L��l��S�̩�)��k� #%}��=M�����'8�O��6�R�|����8�6@p#��g�˷��mk4��З^F��/����Pb��<[�v��:��Y�e�e��3}����@	��;�&|��zO��#G�m����΅��V9�Mv�u��    ���Q����VĚ.2{@7�E�"J?k��@	���$MN��A82�E�:�����z��o���:�\��6"(�c�
�h��a��dh�n����5�?�ת�`PbzҦ��&x�]�|o�/0\Hf��N�Ê�J=�	?8�6k���1ر�d�,��
 ԁ��~ĭ	�������"b�����o	8wl4���ΰc��/;�)P����u��B��aLbEc���-Z��}̀[����I�Cnb����e���/���ft�e,D�|��i(����ݐ�]�b����n^����Ӣ�Ӹ� ���!���Zm�����*�^���WJ��]�-:�������Xa�8ry�F��:�~��~ʙi���0�^�����p�i��~���a�m�v��5���\��H�t6s���!E��:l8m����\����s���Kl����E�����%Wf�:���Nq�VLiZ�u�k���tsl��?#�L�o\�O��{�����\�Hi��pX��U�:�w�uo�F���a�
��	�}�|��~/Jb%:LR#�ƛ��B��5�����=.��N&w����u�K�U7�<��o��/3ẋG�!Χ�F2�I�\���)�zN7�=�O,u�
��p%
�}mk��ӘL��K�m�UU�8A�(���Fn��t���Vt�:�}�x|}lD���[=9"��5D�bU	�{O��������<b�� �UT�Ͳ{{�"N�#�;q�wF:� ;�^_5n+
�
hF���>��Efx�ƛz ��jT���Z�H%M�]��Y�9�,l�v�Dl�n�I=N�5@p���nv��4���L�#�bֽA2���VX&��1=q �]�s�{+_��o8�0L_j���cU�ǖ�+��Z·g��א^ۜ����� �k��[�����g�w]�PX�%��_�%����$5�:r��;�x�����WSsM���}�,�nD�өj�P�u��\�WS>�S���mE�y�[��1�z�|�gbjY�y8Q@v
��r�� P�>꛱�*�y���m47W���_f�C�]�蛽�;ro��6�p�p�Q<.X�?��-�\p�~IA�݅ʮx)&�� �[Qo��T�QKC�o��a<<[���sUWuN�8st��~�C�*��]�FWZw��� �Ry\����	���A�c|3�t1L�����i���%�mGߊ1��KP��鹼'��xl{;I)UB�NPD����7�P�T���F1��Y�վ��@	И��9&�p���E@W�F��@	�	�eVS�l��>��~~�k!g���Z��9۫Ĭ�_���!���_�A	�%y��Qz�S��;CV��ح�b��4��ta��c�t'*�t0ǿ��M����Qg�Ҵ�<:7�Evi����p�cgE7LKp���Wj�T���mZ��L[�I�X�/��e��Q������#���Y�]Nlqm����&��g�0�-�jot/�����E{�;�"T}��M��&�O���s�<f��+�^W�|�O��Rv���(�;��o���s�r�$�a����P�[�Q����;��h����%(0/�^��3�O)����0��.�n���s�J��F�����/���|�9��	@�'�n9Y����e+v5,n����i�������y3��X('(T�����'�lY-:	�aHKR�7���;��jn��%.'L>�MFr������a>yT�,8Û{<��Br��j;þ�Æ�(�s6��O���_���'��V��/%�\T"�7��X��Bz.ό�"�؉������o)���M��a��*?1��:�T�kü��,7\���Y��ޅҾ~��#8��<8_�u���tc���Y9�=���)�$�"�Aqf
����ph��Xi�K����Iu|ڟ��[&���c���~ρ��2��L`kYU��y�ZzO�i��ﺜ,%;_�0�:�[톻l]����U�eT:;���R �/]\��1�B@���;=JKyЍ:�K������pΠ�ֶ�m��l������ϵ��+8�I�L��mĴ_"+����0� g��Гj���t��w�����0�� ������6���?V�?6r�*n�3��"|h1b���U�� l�{�V\I�v��{+��l¼�����g���yPB;��f��W6ۅ��	+4�Z��	.�2��dI��9��6��n����5�p&<z���C�)���c��F�tx}ρ�/X�cRD�A�m�nn��E�]��S'r��I�T�U�hK�?��P���S���ש8c�k�b�WypBO���̄w������[�L�&�ohSs�_��yQX������C	;�c��{��v�vBV��&Ε<���
��NL��x���m�H�Yw��7�%0��ֳ���}pf��z�)Ca�m��[�� nfq�����L�1��C��'(B�m��:�|3ڃ�<U�Z����{�zc���*mⶱ>�^�{ƇI݈��C��4_�Oݡ:S���e����p8#N�����GVN����JC�T^��e5�p(G2?�A6���ə|��߼��wv����U����RmZM�2�[U���h�Ȅk��=>K�(J�%�&��d����i�#ļ�M6&�L�5�׸�۷�~�W}(�'��-Q~/8�{���ڨ�	(Zƥ�d��f����V���W;����$�.ee����h>���Z��~O@�.���yBS��V�
,���V��m�����%��P���h�yr��rD���5��#\Ъ�O99�y:C�_qj�#�,�_dA���t�b�6=��B$-����n��Ly����y9F$����\���Ɲs�C�B������{
΄�q(�m����
��$u���i86$七�F9f	��W�_���p%gk���o�]'�Y��(�2�'E�;�.sJF�T�5"6���}p~�,�U�	fTߡE��/j��Q��(\����(���U#%�M0�Qʜ��/���-^�����4��43.�D�g�ӅTʂOM�5J܁�at������º��i��Gz��-u�>�j�F���6�O�U��4��J�{�Е�s����浒�թ���!^��f�^�pw�n��0���c���a�f�FJ��H�T�s�bL�<x���� ���N��(m���V���P��j=&g�=ٳ�j�2`����ď��?��^ٸ�Uӷ�e�٘��%�ȁ�2�.��=�Շ��J�|"�m��'2�O� �r��� E��ʁ��JW�|_`�9�^}n#7�I�����ٴ�,"�ϝ7��_p�8+Xk���E�0���.����o8�02T�<���6�>�A�
��9Ļ����c�������@Y���6��>���ū_��)�u��ƻld�/�u�<Cu��&J�~Z�a>W���HUn�e�l=E������[�8�Ȫb�[�R����W7�KӎZv�N��]�0��6C��b;	5;�;v�U���~�U�fA��JB��W�ȓf�@�e�huY��͕n{�_X���-PWY����g�P���S�����}D���z1km\�*�]�Y~>��i��YN�"�>�&]���)�Q"��ُ�:�f	[QU_�z߱�B��;&�=�͉㜾0V>V�ꋊ!5J�9�Ѭ��z��z!ru��s����y!��#����Z9M�"���Mg�Z�3o{>�)e�I�uֈB	:�A6��97E֊�A�q
�!!e���~&��H�����4\�R���_&[Q$�u�ł�]��E�yT���e�2J-<U��=g�%�q���m��Lq�\���`Rzn0��Íp�<T���dEE���ډ�����գOJ��񰣥�ވ͆m@�>�s�>��<�/�Tw��z��_���_�8C=�G�h�w�	��%1K��i�fn�`��|`���z�{}@y2Zb��ue�C����?�	gWi[~.˘7!�f��F��E9��� �  \����+<{� (�Bǝ	P	a�L���e-���/0���tf���߸�"w��&V��hk$͝�g���p�H�/۔ط{#m[��]���v����Q�(V�3"ϱ1f�)����Pt�8:lfx#
sW��'��BYR7b~�%8 �Ģ8qH��|["{�x�n> �Ɨ�}0Y�̔��YLV�Eѫɘ_��Հ<�;�V�]�w;��l����Xޭ"�������h!�F�8i����b��D�8��-��hQ�F$~��?��h���D�E�G��9D�?3������up��R���9!�A Dz�jU%�Y���a�����x4���j�ޏ��e~���j�hB���+�'�h+bM�4�3ⷈ�K�<R#.�ep�"�%�u��_������7��R�SB��[��<QU�z~#��,�:��Z��R��\��OZ��&s��{K'�4��-�~?�4����*�3��������xz���؃��1(Â����=bZ����X��~���;���v�������< рԋ���5M�$ ����6��'�ة�g�p�LVY$����J�h^Zt7���q�u��/����ޏ��~8���7�_�h	��\�HAo�`���ǋ���ۜp
Ι
�8�����"̓B�Ņ, �GQ��	����H0�-ɭ���5�'����j��g}������4�/]1=3�l#�RjF���5��x�;eZ���覒�U�?0P�c�t���-(Ph�C�\k�[�{��Υr��߷o��������y�����.E&�tu5��WY�c�I�ZM�y[|��2��E��.Ž��XX^�z]���{�v[��2�0�T[7C����Wr��"NƳ����m�3?�U6_�=1&��a@i,n���!`��Hy%-8Z|	o��������H����%�-�A����������P}O-�j�v��v�Ն�����a����?_��%x���k��/s��t���aÿ�϶�2	��x(��ޑ��d�9�}U=��t�[���Q^j�3�(�I�bcXU(�4��:�ݓ�_�a���GA]P���������=�.Dyޚ���"'�(eF"F@q��Yo��t�Ao:��:�Q��|1"�R/K����,��"nڃ�¦��`X����/bͷ�?�I5����͛�]zn,���#�^ODԃM_�h�v����4��hEN�J��N&N�y�|D5�%p5M��JZg�+��8ٶV�nN�n3&��.�Ӯ�;���u��2���&_�����״���ى��]J�}7�����K�A$r>"v��?TV`���w>U�B^���~\���?������յی;<��	�k��Ff?�?f��|�M$`Q��s�&�&�K%���PCs�ڭ�'�t��Lz
�:o-0W�Z�"�������~�Ё�      x   �  x���Y��<���Wp9s�S�މ�ʦ���U�BA�dq��@=-���9�T��$ݯmrpF��z����	C3j����'��f��&āf�ǵ�� >Ӄ�tnOM3i�0�����@(�%�.F��Zm�]�����������R�AAn�����H�s�p�s��f�3&<:��0u]3*�s��zIy_k!}-�������֐�5ō��	O��O����� l-��ː�.J�Tn;�Fg�<u:��T�7���C�o�D��Hq�L�
��>�eʘl^�Z<����-��$�h'.���/�Uh�S{��7�Z���e/�/s�=�z����*��ÑQ�'p$Iསs1yGk�x~�T��]Y)�^P����u0��i%�Ԟ[���Ë���v�`e�vBпW+�A��]��eE=���1���%�]e�ƛ��~G`�٫�f�����Jua2�^�;��s�XiC~R�z�~����j��|��]�X>�h���tAiG;����:{;�F�eF��3��S�W�X!���AC�t}�Ă���$��Z9���U3��2�;p�����6��!껷���.�^E(𯉉�Bt��c31����m��}VA��@��s�b3��~�>/��!�t���t\aeEnZ�fs�1�p�FU�,��S�d�Ʉ>'s����6/Iv���qj�Ƥ��^�@��TRw}s|'��m����f��-��F�i3/Z���6꺟�����2�����*:����}�?D�ӈ%�Xa:��b��JB_!�z,����*�g\r��zj��tW�� ��%4S�25ăС8e��ꨊ��R>��;41�����b��V�Cs瀱��X���������+a�׎�ԣ�A�п&���-e��G�� ��'��G�~���8"�f+�h�VT���~�S�����YK6�Њ&\"�����eadt��64Է��k�M��+:��������Oh�s�c�� �Xp{f�(�����uL�t��̬hDʥ�9r i���j����Eш����n�x;�q^5��ݻ��,&��	�V�"����(A��P�P����fhE)�rp�.�{W���~z����,������\Blɫ�8�f".t�Od�R'2� "��a��~WEU�R�4��kɶ�'�O���M(�B�D�V���5�)X9JA������+d,B\�q�������]OB:s$�=�:
\����Fhe�l�:��%:K��֮���v�}k4
�l��j1����{�#>x�O}�����Z�jX�^g�,������u�y�zy�[�Q@e��7GES�d�ٝ��z�@�<Q�Um�W����t���T�����5]� ���g�_���V ��Q]n�������T.3�;���L���n��x)[�_F��;�*�� J����{	]d7)��73�� 8B�y�A�'��E�p�'�onɓ2��vllw��!䆁���S �.&Y���"�AѲD$����B.��$c�$n��'�3��IbF�{٦qkm�͟�w�'(0�&�D���8㣦9��^�%,���&ȷĻ(�y��ކpλ��sc��� �(�뚻$
~$W���h��������߾�bd���F��H��a��� 8�B\5':(Zݨ(�-"�U{xĮ�%?4\4H�%���n�a���J]	��ޘ�����4x�����	����j#�� `C�Rq~�
�mHa%�s���z#�K�Kk5��;m�[�Z�Z�r�]�2�ȶF{���.�&�����9o�F/�x1Z���˚U����|�5��Y��H�3��ս�����Fx%�ں���������p#[L=�>�o��QT�gj)v��ȹ]�{�J��x"�!���[�_���ᔭD��Z"��[�2���g#��U�ᶝ�ɛ#7����GG(���¿W:UT� M]a@������z+�
k�|6�+j0��"%S}v&�l���7�����hDW@�{۾���l_������l��4!�ʖw���։�JP�ݴf˧�S�͟oF.��G|b�8ml��q�v�OP�4�/�:������B5#e�1�=}�ҷerh8'����(��H�)W�k�~ҿ�wiss�rߺ o~U%T��Q����l(��X�q�Ŝ\>�R�\,ս�dxXL�%��Q&���Q62+�t�w;�ZP�\�ʨ���B󒘯G#��C����U��.��`Fi�???�O#��8�ݥe��4��I�N~�VO�d�����ѡA%����ʭ�`D�.�^�-�{��}��,A�Ͽ����&�7�J:-��y��E�5 0�+�Z�"*�xc��
�e)�ɐ�. ��K[j5����bo�X���]�uA��t۹��QXEkN�.���(l%�wa����@?<umg���Jyz�vd��5q���﻿�|�"��>g<��)�x"I��jHp^�%]͝i�#z��c$Mwg/,	r��j��MJ��3���4�_y�f�H���9c�Q]�A�ŕ�`�x�_�H�e-���lE��4x��X��UM6HG��OL�0g�*��,��v&�>�"]�Bq7��
C���ǗV��\�#NT!��,\�� �x�}�$�
e��UT{�;؅(��n��}��u��pR�O�x�]�`?�Q_�o⟝�ٺf�����P��G�7ax&�D7����.d�^�����A/A\#�h��}|��H]��M� ��	���@��Cu	�,��)x;�9Ad���U���}�f-�U��m��/��h?��� y>����ڡ�[��s�$�W����]�������r4���$�I����[�5�CjP��,�u��w��E��=�͙3&;kVop����ƭm��c7���� `�`4;Z攙��h���7�m��y0>�O�>�CŁ�6[�6ji�(�V�ۂV5��"*�k��e�Nf�P��čm"s�����QtJn$p�τ��孰�r-��ۙ!�`�#0�}!��ӁG;|���{�ɣ�|}�r���TO�py�[�sH��Z�W��s�|���ɷ%��'�c
�F@Pd?yԁ���n
,?A�d����.��2<obԑ�]w�����|���g���B%2˒/��@v�L���KF�c0��dq��j;٦��P&ӇQ�������$��L�Qk,}f~��/p��_\���6�'܊]�d���"]vHg�ǒm��c)t�b���+/����*贁s�T:fC܂G�k���� RzBS�g���bV���_<��^E؈(�X���+���Z8#㋨���ߵ�;�a'#�Q~>��2v1�Y2*?wa\:��?����y�L��R��D��r���q�^-�oH���}�k�qį�4��K��&�G�X̢�,���� 2�-Q��G���8��D�K�đ�ZK��}�����M &Ý'�*�;Z�����ڟ����.ǳC���:�����W!��M�Ryxi��y�E�Al)J 5j��ܲ�PX�MmD��В ,d�!� 鬅s
����H�����ɢ0���� �|�=�8��`�5^�aV�5���~����P��x�c��0�g�ϟg��&�O�:]��E:�%�:�ܔ��3"K���}�_��+!���G�w"$0���i,O�F��;���`z
A���ky��}ޜ����9F�]���x�y^ -�����>{�\��>
���)����Uv��Ȓ�|˲9���C������o�9G{(ś��o��q�z����;��S|o����hk&�����v�Nva�G�CC�;��<����[֟�wQ��{���g.��VS^��P���������,�R��i���׍{�O�8��)�(���.���^�����:��P��h����3���Ekb�I��4M��;nI�(5/���� .LXs5U���Sg�J���uGq�]D!:���F1aB��JW^�g����Z����>d&�7!�lv��m��y2!��|
�M���gݰ����w�A�׷��O���/���      �      x������ � �      �   {   x��N�(qt�NL3��-�,7v����tJ��1I��4���Lw1(�t��
��JM-�4202�54�52Q04�2��2�D31�25��K�PH�H��Q�(-MI�T��/�I��4�46462����� �!Y      �   �   x�˰7�4/KL3�*O��N�(qt�NL3��-��4,�w/�41��uK�450�3 N#��D��@��D��������M����Ԍ�+�4;��0�ߠ�ʥ,2îG/�ܪ�L#�̐��rN3BvA̍������� 
�3u      �   s  x�m��n�0 �3���)D�?�OM�5��$�;`5Ћb��b[Z�4���7`ú�<�<| �,���񐝃�&�Aj{Y�{��l�ú �]�ڒT��4 Ǧ�U������6����"�N�ސ�ʂ�2�m^����F����]�R�ȶ�Q�Nh8A�`1�\�~Ʈ	�W��b�U�E�m=8�:��f؟��I��c�6w/�ﭺ��
�g8�8�p�����y�?3�S��d���{Ju�ҐR�}��+e�k �(�S��.���h3?B1ڇJ�(���lƷ�!������s{��d��G��	~�Zv�?(�z^�я�7�8]/W���S�^_���Yd��^��t�\�4���
���sz�8)c�N���8?�C�      �   �   x�-�M�0 ���:+s~伕S�6�2�؛�4uA��=燬�q*�Q�A�
��7硿�2�ZX>c�B�jF�k2�X-c��Ǹ )d�=ԅ�8�������$n������e�l_?;��M~�o9ь����z�C,���� �>4���؆a|F�-      �      x������ � �      �     x���MO�0�s�$�Y��
�͖�Qg\�.lv�J2A٧��L�bLl�4}����ߵ�Ջ�������b��ۍ�t�� ���> ��Z'�9H//ޓ��!�R��j�J,F!�A3 b���CL�l�9��ᾩ���\�ަn��'(��2����E�w=���J�)������eJ��ƒ�e�;ʕC���E��.�'[�n����1��!�B�#ep� �,�=yw8�]0�����H��p��@���pV3˲>  ��      �   �   x����r�0����)�:7!�$;M�
A+�u7�Rl-�!���m�蒳��S�?�Ir�>�ߋ�|�����������C  8""��7�͡,6����[��5P��G�G���1�����b].�qd��쁝��<�,��7�cG�K�D�O��:w��Cx��8���+i� ������
Q��[m�k��U,�06ԗOӡN���1�n:�]u�k�]��_4u]�      �   d   x�3ȋt3���Jww(L�4(-�����M7�H���46 =�	�2�]�,]<�3�RSK8��Ltt-��,�9c�899M!Z�b���� �x      �      x������ � �      �   l   x�t�OOJvM�4���-�J	+O	�K�*�-�42 =�	���s�2��93�]�,]<�3�RSK�J�Ltt-���LM9c�899�Fp��qqq R�      y   �  x���َ�J����/�O��*
��Fe�Asn�GdE���vc��s�6��G���_S����X��6
�G��^�߸ ��o~�
2e@�?n�/���\��u��[��%����Q�`�5 4�I #}Ɯ.<��t[k�i+�k�i:0>�������!����2��й,�|Ƨ
1,�%C��/!���
���d��Q�H5n3r�`��K��GhU���sc٧��(�rXD@l������S�8 ��\��)��_a ^� .�b����5�;%@2��a̼Q�`!t&ݥ�s�yU�C�SW[8�$�+'�&��N�5y��!�Qڛ�I{_�#t���ү:HZa?��u�m��
Ϟ Io;sC��Y��i��^�NZ��&�W9Iy�!J2�^4ˈ�a�m���S8W���֤�9sG��-a5�� 4C-���7��E�-/�v0�v�
�;��:��C�?LY�5d\A�%�S���a����tp<�vYQ���gt������-�3O�R���6~`��K=�uů��۶/?v��TD�FF�{�A�l���� k%����f��Ti��>h�8����9Z��J�w�T�x*"�T���
�7�2�w�kr�y�m������C4OKʥz��Q�s�Ǹl*��m�V6�F`��g�����m`���M"pO��ò,=�o�$�/Ȣʚx.�v�I�e�8<�TA��ZQ�٨{I0�p���ߧ�,��u�[q�k����$�R�k��'�G-[~W��0���0��h��`C�HF��?4z��o�R������̭�]A�ᘦ�Ȇw3OŜ��?y�k�e���x^�Q{�T����g����|Q�rS�@l����[V#`=��8�[��M���Uqۂ�������>Lh�Aȶ"��������5B�֚VJ��Sz�T���>��n<�s�K������I��ʟ?��?����<�c�ѳY:���x`f��>����Di)�?*8��*
�{|���2t��9���=_Iw�mu�ۼ�����=Pg۾��@�@�ޫ������� �> ��]��FiU�7	���b�y1WÕ�8w�y�s+H�nxǂ����1����	�1<k�-�>�����D����2���}^�Cg���K�a7Py���g�}�ȭ^���3i�J$��mEWXag1�/��}��gk{��;��5�S\��M̯7`�5u�����@T��A~�X�I��yD�o�G���w˙l����y��vEю/��X�h��{� ��z��1^��2.{YVa��\X	J��ƪw[�`	��}��^���V�r鶣|���Jc����jv�q��3��vYPJ��������P�����Ԏ��I84h���}$�Rh%�M"%ִ(G[Q��q��
s���6/���t��բ5����R</���{�~��u0�lb�Udt��+6���^Ԗ��:�i(M'o�������N��      �   �   x����
�@E��_�(3^}�"�2�L
)�Tҙr��|}���^��a�Z�ڕ4]�M�JIhX�%�Dx�3��?��#t�GYd$I$�H7U�Tl��`�6l� ;!�r_���<>~�H�(��r���R3>���tf��@��r�;�%	��l�~���n�c���}�8Y5��!g����~�o5EQn��Vr      �   �   x���Kr�@���)r�y���f4��`��Qn,0>b$�U�>�r��^����M����s�.M��N.�?��8�I���Ԩ��%�#�j ��F,0QL(.`� �v���>�����i�o�����3b7����_m�V�^m�o�"0���t�-z�@l�Y��2i������~�z9��"���|��=<iBe����%p���抳+MZz��<��[�      �   �   x�ψ0�u�	�4-4�(��4��ÇR����S���2��CC9��Ltt-����L@�8�����3"��$�"2;/4��"���%E��h�[X���[Y��ԣ�hfeh�b�!W� ��1�      �   l   x�1N���L��K�)2�ψ0�u�	�4-4�(��,�tO���(�1w�����425�3 Ncm���Ltt-����L8c�8A�L���L�+F��� M�T      �   ^   x�+��*1��s���N�1N���L��K�)2�0�3 N#�j�T�Vn���id`d�kh�kh�`hleljel�������� ԕo      �   ]   x�+Mu�4LMɱ,�*6��1N���L��K�)2�45�3 �Tc�b�԰r��@���PN##]C]CKCc+cS+S�?NNC�=... U�#      �      x������ � �      �      x������ � �      �   +  x����r�0E��W��^$�hK�f�1S�P�ap3$$`3}K��`w%�\eJ����{R77��eQk���؈�1��`��J�9����@ �;���@� �X�5.נ� b�p���@�?�m�7��a�[���8�8��#fI��[� `!W�����(`�c5_��Հ�� ���4E�7k�4�P�p�J����a`Vl������;�F}R��O:D,�$��%�1E�Bn��}{��u�7���W~^q�(��V�@�	G�s���~�A�*qZ~�tu8%q�W~\z�EX�����$��ࠃXGS�Az�{���v�~�N�P�,=I�B�g
w[]#�Q7[�.f����"q\/�0�w��Q�z�2��hC�
ʽ߽mq�ws��VRsM�V4����`�F�P�i{xY��]4n5%N')D��N�.���F�����B;�zy������R���I�{����"���]/��"��\����.�y?�?�Z�	$&F���w2~����݌��gz�J������J<Vi�^z�FgI�����emkM�eR���(�T$�0�H���(�g_x���G�f���C�x ,ޕհ�$�'e�ةt�i����"����0�欃,���I5X�߫QY���Q(<����o�B�º�cՒz�64-�`��)�y޾�ÈɣQ��)	�Q<gB���=��F:z.����/"=��V7V�ӂu���f��IB��鳫��W�Y��6���**���������u���m9 �9�T�e��Յ�o0�e�/>R���4�?�	.�      �   (  x����R�@�����gwY4��3���0ƛE6���z��љ�i��\�9s����a�^L��_n��#�T �1B@���������J˾uǉ+D"TG���̤�P0{ ��tUŋ�:pGYj����4��t�)�������fb��M.U�z�J��Ŝ�&�0_AE�X���
��K��@:/v����d���1iKe2��7�.�2�M*�����rx��V����i����;���^�#�՝�t~��?d�ɼ���-ȽW59�y��*�b�����i�7�,��      �   �	  x�ݚ�s�J�����ǹU�-�������u_PqE�����,�IBo�\�K�
�Q�g�sN[�	!�.7�#ˤk����;Rs�}^k��5�k���m�,�Ph�u�Z2M�,S��:n\})��j������n:�b���8�Ո'H@��A��A�`-e&������r�=�_�/�n�&���7O�D�d�o3>��>\Y���:�!�¿ �=�������Y䪈�2ZW��-j@�Ki��&~\�G�ZF�ytu�ռ�f���E����wM���	?8����t|�%8��Hˇl�ɪ��<��2Ԗ���G�0�\��GQ8�}���@�r'�)�$�'-RL�ć��J�p�:���ז��P+8<w���iP�B�A�	��K@�k
JJ7�o#��r�\�]8Ge�� a[X<1W�Rg�o}�X���F����`�t�����j�0ق�`3fe��q����J�f^�l��)�	f�U_�z\�G(~�1u o {CUH�1è{U�p���aI�Xoi���=��<��l�k2��P %-;Ǖ;������:YZ<��+�O�р��fL�lZ�u���b�
Nq�,�V�*�:y[�k����x�L�{yx�`b�}���~�e4������l�4V�2�1ݜѯE�k [/Ee~艫��=�(#�%���4��Y�OG��m_1�`��t��
�����=׈���V;��K|�\d�1خ:�
3�Ru�j���gӭ��u8�Q�+�Fڴu96dz�)�7�ʀ?M_P���n蝬@��������s4��O�|<wP�]&'�9j-arGmZ��ۉ�ꊹ��A�I��4���.�SҶ� �T����˰b�4�������E�]%OۃR)Aw�-S~Y���ʞVR��'@(K�����'��Ĵe�O�55��s(	o����u��>'��f4�b�  �	�x��%�o�������#Z�5���C�{b���
���+���՜'���E{_$���v{���6P��-M�oC$�`��+#����U�jCi����G�EЛXI؉��ha1�e�8�r�C��q&B��|Z듽�h�G��c3M�͉ޒ ��<�T�,:�ބ��R��%�_��#vO� ��v��eq����䔎]�[�JJy��ͣ�0e05E�y�eR �l�I�d$�y)���A��`X��l�I�+�h���F�F��u)(��/�@��,����祰��b�%1n�B�")rW=���~�\��Q�3<����R7dΠO�]{���l<���"P�T�tK#Օ7�'׏�������<������@��t�wO{^5�f�P��J��XY_�X��J��<5��$���wr���y9����*f����폈�M�Q�;d�ݱ{�5�TE��u0 ��� �U�8�#��z��Ҫ�J�,T��rI{ټ�d�j1�;�\󋦊�b �2���)p��6���G��:i�Q�-^9E��xy���@���rψ�ݢ@Ju��q�u�i/��H���!͒Yb;��|�3o) ���|N;8maLe5��@����m��]��:r���欃U<:����R�iU����;�!�	0�]�>�lN�~}i����Yi��a��]��Ի U�VB[D��8P����ZF���(_��O�'��*��q�*���摊����+nu=���n����*t�x |>�ε`9&(�+����|' 67���KA�� �P��T�O�^��uX�3={�lYP�����k�^'`<�%:�b7�$(�Z�Ғ�P>;>g���7F�9�E�KM]�n�̑
�*TlП��/��+4zQ0��ٺ�m�J1J�A�,mej�in#��A�yT�[�o^{����K��� v;iI;;U�˲_I�8�`�$��0�wFd��C�#	�\S^�y�H�]�.�ZӘ�Q,¸�ۮ���bN��i���;H���:H�~��t���"��=�������nyn�<����Z�TBe�z�'�e1n�tW˜������B�g��;Bޞ���Q%yaGE>�'��/�(x���ja��`O��6��ћTu`����K"�KC�a������r:�R���c�$��?#SY�5�aO\I�{Ө��%B�������)룱�1ꡩCcI�y��['2�&��:`$K��Un�$ �K!�|�����vu�s��n�0�'	ŜO�N�H� 7 I��=���/"�ԕ���/���a�K�j_L�\g����i�R�Wl]L�|3=eWBv�j�P���[E�5:�J�)3��w��qd��x@�I4��.W^3��	=1�� vxCf��8b]�EMqN�`�" �?���_1ߺ���`���ج�nϯ�W��͜����d����-E&�K4S)�0�䟿�}��?s�e2      �   j  x���˒�HF�=E�@Od&wv��"�A��
B)>�hwW�X33���UD�8_Y�~�T�L��2�M|�'�5
�X*��3Nw==�CS�0u�lL3���gJOAg��N��0�}ր�,�YY�t7q���C��c���0/"t���~�
��[{n/��}Ì��"����^��m.o�p�TV|��wF���3VDDd������k9rk���@�2)ϴ-��)��A8I�~�Y�_�.�ybq�f�ٴ��I��y�Хr<�I���=3=�/y�<Ac�],�4S��NI�_p� 9�P"yu��^/V>#�J�ڮ׫��5x���z9�V7}, V��='�$�� ��j��Z=��ީ���Ua�]U��S�E��K&+�͢��Q"-��?"��O�g�5ԩ\�3����}�WS���Õ�7������).5X���Lh�='����>c$���p"��0��1ת���ۆ�k��\��0Rz�V/_�Ü��bXڐd�$����c~�@M��K�E���~	��]���_HiE��hΜzfK���um��F�{u��r����6��յ��s�g`���)'k#R�����c���Z��q�4-�ާ���l=�N�C_r�퉑1�봿��)���u��1�N^w��6\6�EO:���ή�]�R�.�I�H�B����shC�Q�2�d6_i*P������q�gh��C'���h���E�z@���uҳ�1H+���1Z��^�l{����=~���������ȼ�"/PC�w���V֔����1V3�����A:}^ߦ�S�o����6]92��xG�u(�j������UY�oL������]�/�����	���r      �   v  x����r�@�5~E~@kFv* �@y����A����HvdAY��S�ou��3>�R��-�$cZ�i��^�L��c1ĽX^c�OF  u�EP����8K�4~���߁�N�_!H$E��(�z��3�v'9>b��s�x��^<��W�HBSGJ�)~�W�x{1e^/"�=z�嵋Y*�^���6A��L:X*4������s�x���6��<�E�٬����tq��2��ͪwz�~�9�%��wfc�&L��ω����L^|ߴ��ᡀ�o�e���U���jt�����z۟�Fߓ�<-0����gu����Ȫv���x$��r��M����jX'��N���`�޺��Q�P_8�L�ﭠ0�_�n4~ �SM      �   l   x���u13Nr3��M*�	,�4��Lw1(�t��
��JM-�4202�54�52P0��24�2�D�+XYXpr��d�sU�����[�U��spp��qqq ��      �   �   x���MO�0 ��3��[��΍
�@����ܤ��H6��z3Fo�����#(j�~��ڤW�����䊨�����|H����;be���4-�[����+dX2�0���Yh4%�䨽v�u0�,�.W�qqO�Yn����Ly��,����Pj��=o��?������ `�$PY�>����=&����io�x)��C����3���_�^pж��1�q�����j*�Y�}���]m����t�g�� |l1�      �      x������ � �      �   ^   x�+�*��I�37�	�p��L+Ȭ
L�HL�L�*⬮�44�3542��Lw1(�t��
��JM-�4202�54�52Q04�20"�?N�=... �?;      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   Q   x���L+Ȭ
L�HL�L�*�@�� �!��)���g\jU�U�i76�7RPv�>�6C�?�=... _7Q      �   s   x��+H��
5��t��,q��L+Ȭ
L�HL�L�*�44�3 ��t�2KO�����N##]C]#CC++�?N�2c_���b���� ��b�5��l\� v+�      z   @  x��[Yw�\־�~�.�ս:�f\�.�T�d���p@�A{����ʛhc�z��h�s0F���~������r0�Q���`�`�:}&
�� �ɴ '�A�  ����m�
�Y�F�T���4g�,���W��:�Y�k�[�;ǖ�����ke�X�N�'r����~,�����b��������@!��w'��d�� ��:�ܙ�U��F'���-���&�fa(��B��8��T��劵Q���̈���TR����M�g����na�"A��pGO�P����nj���e�9،�3&�~��n��w�P��C�N���
�3�ݞ�.e/xz6�|�( ��@�����[�nCCZZ��g�p{�E7����t�U݋�J�8_Jm����uƖS	�+���� ����e��˨�-j"�3�F�?'�q3�'��`�fA�8��2@�Ä���|Ʊ������.�*Og\0^!X�B�,W�'i���̈́ډ���k
�i	7 ��2��2�`6@h���Ndd���߀��4gE��m��t��l[S�S�9dY�l�����a��Q�<���π�l���lN�\Б'@#� �euiT�`ZZ��7TGpB��L��C��Pbg��M�� �H]aS�9��AU�A�]�lr�#��&D]�]�W."����nlm<8-���l����سH�cQ�x_8�,�Í�۳�,�]M�5��W�$�[{"���n�����s��W<�}c9.4ߏ���O��%%��{��$ƪ2iͭ�҃�¯�\�� ����� ��A����'&�t���.]��8�w�1x��I�H�����'��hQ\�cl��~6�=����
9�>�L�? z�+���Fq��g��NKk\��V�6�A4�~:~-�H] �fi���R�4/<e���8�a�}��G&:�o�7�`��`x�q��G�$�]!�V�t�gIϩ�U�ѕ�	�p��xx9wX�����˟�>�A�L�� ��/QOΌz^�2��r�sRX��6�IN̼����8F{Ac�P/�^o�]x��r~��b�`�;�W�r	�Z�O�����~�3�~Z��hL�Hu��/��B�31��Iʨ��t�0��!~�,�\˶��fKr���@혽��e1f������l��r�	���4����CY̯� �`o���&k&�7�-F�e��' !m����0����w�������M����C�������_��RvY�"�-�l* כ�%���\�����9�,i
��9��������oz��5��|�u�ͩ��OS��	�PU�fBKs絼��T֨���?Ռ��و�����b�3�Ĭ}I����?�b\�#W{y6� ��>N��j�U��I ��9���4�b�ww������f�nG�5 ��ރCY�����3}0��喋�F�ȕ0�H)
��d���d^H�+����+�FI�Ja^g��R����D��e�Pt�F���7�R�S� :��t#;�]�y��]��zs��Ҡq�����Hn#"���'b���uE�\��fR�K���!�X=@� ����s�n�6;?-�x����A���	1���d�{��:]����X3�g㏨Њ��#��Ƀ��]��M���r"���;���?Vڮc'K}��% ���T�"�<�޽%uj�9:+�E�-u���j������X�ȁ���`����>���Cs�m�]Q���h;�ؠBb�w �e�{+��[�yѴ}0��L�jS�3��c��n�u�����1Z��v1I%�=���xL���b_��oӝ���H�pj�e�W+�d5'��K)w'ng0�2�)������\w^��Ό}R�����!��U����J&��Jݫ�48���M��2����r����ZM`0��B�5���lĞ��1f�͋	��O9���gu�ñ����&'s������|C.slR��:N5����o�Dm�}�R��8ٮ�eV�&S����y\�O'�i��k�� �C���"��r9����W���(Z[�bM���
����d�.l{2�d��/��!�ƚG�������ߜ��T�'ލ�����!p��fh#��B���X�����8�#�6N+@a	js��� ��!x�y��>B�|�g�`��@�O7p����#k�h��z.���PZ���V�ø�oYc>��mL��`�5�ޥ��[�䮿�����$"^H&qE��͵̥��b8s��0���l�����x��p��'��=##P��
���)�� j&߈,U��h
����O}��<��Ҵ��$�YWCr�^���e���yoW�����c^��ҏ����{�'����M�Ǿ�%���"S"�H�o��"з��?��������}��G�<����tp�����5|���p�څ��[�����;Rq��f�d�������o+dDzܛW�O����z�N� ΂U服��������Ǡy��W�`SF�݈+���43����k���W}yKIv̙P�[���Y�t]����P�v��mmmG�<��?�;�W����У�E�v��\S�эG ���Rv�z� �%)�|Qо�K� �6��=��`����J�=l���[��?UH p[H4�E�ᭂ�h�a��uƳAhX����	�XB+�~� �E{��4���h7��g���>�����|�H��tP��=2�w������`d[�E��ܞ
K9��A��S���&��ح�0��0�r9�g�C����%N%S%���m��~N�ӧ�o̖]����)��R���v@M�D�Knp����4����up���z���^E�bE{�������qP�R�ح���o�C�_�p�#��@����`����-0W(2����F>��/y�;�������������=���e#�jV�*�FQ���/8���U6l5�a<ٱ�#W�Q�q뚶6	�Κ,����/O�"s;���0�0���j�i��kC���GB���Atঈ2)Qƻ:��֙�?��������p���#�+�����K��H��_N�m8}���ӧ���u      {      x�͝Y���ְ�9��.���v��D&A&�xoTD&'~��VWwuW�`�ߎa�w�'W�)W&	rP9�ly��5e%��8��Do]N
 �o�@ ��������_'�# a�~�y��W���|��W{E����o�x9[� �/���8Ίb��$����J�M��� !F��y�@�`Czd4+Z��`�.@@�1 �Z��+L��E_�τ�`=�3UI�%�I�'q�����+q��40��a�`ho|Ta
�ao�ͪg�H �O^�8Ө �@8��Iփ����H� ��(4+�( �#��<�����+H\�)~��u!�v�n[ީ����_4���}� "��';�TJ%{L�w��h�-up��G��*�x�S���y�8s@Ũ��/��	�E��p����]V�L<?��Ǩ��H�`*���uQ6�_ƏQ0��+���8@�}hx�-m�Y��Z7N� ]�&��a����8!X�7�a����&�
��91U��D
4_8��_n� ~�.���bЅ�+ܐ>0z)�iU��c�kܫw�0�"���E�
��V8'�:<w�^p)��9��qm�MvM��*��w��O�	ƪ�b���%�"}[W�ōr�	>��{�%�v�/�:�!_�_�e<K���]z�(Y�N�¥4�����W��Rm*��腆���a_�g�W��?�Xg��*ƵiC���~uN�M�|F�b`��T��P{E�:*Au��C+Jv&��k�8����ae$�o^��Y����%���@�:�� F ]����R�)��(=>�^&:K�<1�g�bd�G���^��;��ؖvޠ�H�N,�!�ՙ0�3�J���r9wq�����yI�<9\�Sp���_��l]����[���� ��j� 5����@��W�1�.jb@�'��"�o��嫒nMj�Ɓ_!�g�+��b��?�Uf��ϗspe)�����@���FHEc�jdsËw���H(@�v�fD[9�О�eÁ�Z��� �����:f\��7��j�t���~,I8�#�΄��G��uqv��Q����Tq�`�ΡA*��g���mZ���Ξ�[;D=����&,�k�q��|���H���'��A�ͼ��P缻�	���g�	[��W�8���\_B�sl�1�[��_˒���t�i_5u=��V	��4!�l���O�6]oQ�e���TFD����"Ŵ�n��E�jP�<�F�����dq�W =bd��}�̡��>�c@ �#�I�b���:�bX��� �7�bR�`�e|Q��;P?�.����-�Cګ%,i8���A�̿���c�zu���Cc��ZDj-}R�D�<�YRu�~6��s�o��V�BD�@�j�;fs8�,��J�_�.@��.�����"��m�q6:���4^��Iю{mz���D}�<F^,v���#ޢ~#��K4��㎠i�T�%u`�&����g���&��þ@����!�?\J��|��n'Mpo����m���Z��Z���7fe��S�ͷ�bi�1�Wբ-j���*Y{��8���oio%H�^|KZ��GZ�e�"f#Z����	"�A�X�5@sNe���b���es�_F�+,�l���Ɂ�y1�/a���g�:S��d3�Ȩ��\W�6[]-i�4]���)q]��]����O���:Vg�:�g?�K3���]�4G���Xg��8��
z>\(���T�>�~ʀ��oM��u���x��1<g&��ꅵm�9��+
���D�ˁ�����T�)iyN�in�Ub�����kS����U��5��'㒛�����k�Q�P�p6]��'�r�=S�u+��haNb!u�Qh�e#c��X�c��a�34s���~�6+]������Q,���1rX��F��/9o�Lۜghəţx�A~�Qj�l��h�s,od`I�KN2l���u��/`�Fg�13XfK���_���t�A1H!�<�h���"}�TE��4��J\��(��>�gn�6�=�U��f5��/5�k��0���H�
�BI��6���-�l��s�*��U(�f�>%��Tb,�X�Ɵz�{C�h�`~����C_!�s�l�J��8������ ��#�˂�1l�T���>��\e�
�ib3V Kr���ڜ�h���O���}>PEd���:��Mt��b0�?���V@ (���$�BX��!�c ���ң���2p�l�B�x��<�3�+�:����Q���)��	L�
U��~�Fצ5�:Ԓ�6���;�v�6�ڨ�Q�m���p+�y���C�p�\���@�3mP~�Ն�"���Q����6��sL�{'�CՃ�j��9�vڡ>D���*8ݮ�hv���l�]_4Etx ��D��b�u@�6�/��WU�y9�>�j��A�I"��T�ŐVuK�̈<�e�f�6��r���>G)�
�|�>G���ȁ��	{!��V�g�������gz��҂6p����џ�"�G�)*k�Yb���j �u{��6�x��46���d�|�)o�ҩ�H�|�8��3e���b����amK;E\\,��:��hƋ*�VמZ,�8���I���)��m߁�EH$Јv�:�'��g�.FI�~�����"�-���/��h��SE�#��2#BK]#�;��۲�\�8�KL3�h=VHﶜȧ9g.`��E��p�����}m�BC�=��	$x!6��V"��J�Pӕ�@Rc�n#uv\���G0<��ͺ9E���Z=P�d�1|�~��W;��V8���ap(:���U�!�<�[1�^��4֜��pi�H��80���u�/0���3S݆��Q��0��խ������Th�{����,Қ�<�F�/2��|�2|��r9=CR�JI8�����nC�T�K�	�-�s�{(�ۙf��3�m��Q���n'ު�S��>��Z��"$vܙ�Bu�g~0F&'�����mc�ȈUQ���k�#���趤w�\�x��u�7w8z[����T���H|g;i��q��Lş�1WT���fm���$P>����n
ѩp���a]��2����D�Cр[�b�����UΩ->Ct�Ԥ�uYy6����ݖ.GfdN�22F�P���V.c=���D��b���(�4�'��ey�k���lX�)8V�;Qw�]۰�S�&C�
K���H
l�k��n"b�u�u+��S����@����yB��ଜ5�j ��jҶSH����^縷W�u��#lO\�ﶞC ��O�i���t�ܑ�C!�w�^m'�X��{5\/�|UQ���؜����ػ�y����0{C����_һ��-��e�n��~AX�=�y���3礣Go�������ۋ�q��2ec3F�R2?m>!,Q�≽���L
=V����G�nߋ����vZ6�4�|x�}�$ ��$��PF�����h"�f�m�P�M�Z�$7��w��.�V(ݍtzf\l�\&+��N��gN��J%VRj*BG��� K�ha�I��ݭN|�O���|b�a�З/]"��^Z�
9��*�ḖFڶ6�%�[��H��1S#$[�� B�m���C�w��T$&g��F?�(�'�Z
'
0�Vwb�N�ۜ�V����ȧs�����-���o�/u l��@V�T����ﻹO4<j�o=�?�?d��׷���j1�� �L)��n��Ԛ�Be�`�l'�y-$�ğ=��k�Z��n�g�H ��=�Rc���d�ڤ�␝א�N�bV޶�*�.�a�Z`G������$������l��!枔^eM:V� +Co)G��@q}�!E�F1]N��)�D�{���Z�ˀ�*�l�K�G��%~�:L_4�$�I���<���w��0�Lph�?�B��VwĿ/�;�0/���U�s�G�R���v�3/�',7E��Ͷ''}(�c�c�
��+��N $�R��0�o����0�?/�����f��i��o�c�0�
B<C��R�s�D�x)    �YF���W4tnl~aCn�����S�沦А*�j[�K o��۰A�=��h��U)V�*���ٌn�-��pk�&UXK��]��;�49|g�*1��Dw/��x}����q�G�,o;�׎Pg�;�~��\��K��
��d�魹��U���m�\��m���5��u�l1�����^��\���gq�hgǩ���*f�8`T�t��z�Ef���M�`�����+m�)�� 54Z��JھZ9y�5m��������?��l�ll(;5
t�9l��[D���\�W���?K�qz\C5�L�'��g�K��_�����e�ޞ���Ru��W��Q܎�ϚO��| �Ӷ.ۯ�<N���~�4o�u�g4�.�2�#'o���e4Ai��j�V�ę�*v��ܢ��Z\����䡭�搈N{��J��tX��P�-���"no����ߌ��	���6�ܓ!�8q�㟘�>�v��截��8�R�����%�m��`	�b=d�K�v�E����a5	�����x�?��������?��m�r�T�U]��{%N�:@��t�<`����mI�����)���9HzA���D�i�K�*� �ob�js���Ne��p�B��4Y��5�����Nw�b�'��
����?�����Y�#���qP#��NSg�=����Tl����kw+v0H�I��؝���b!����k��L63Ŷ$��]wn����e����u
*N)2�t��e#ﲩNe�0;�kü���lT3��l�T��2�'Z���掾��0�N%�4�Օ96}ecE_K�~�v�q��`�%M	p_'ކMt(W�O� &��"���-Nl�^�z��j�M��۩�ωA�YrNqZ2�ג�7�T�r�|;-�x@�%9>�x�3�ݮI�̥��ĥv�ϝ���kl�Z���mc�3��\�	��]{�dk���h�N��(8Z�����|US�.��N�nԤҽ�d�ؙ���=eu(8��3��P\��v]3�_5Xw���X��M��kdV�1>�6ء�Q�X�d�V3�(��
߭]�cN�����Q�|�g��6[9)7�ȱ��#尞ׄ�yЦ� �hs'.�β\N�b���?k�.��pQ[����1 YvR��'ٸ,	撽��ɏ.�G��[������?�B@�};M]�e�	�^Q��g(�z��Ԍb�L%�"U�u���LD��k� �O�WnY��&h��j�hC������J�@���C7�C��Y��z����P;����O���6�D���,�Rfئ����fb��İ���Mp����$P�ʭ���:-�R�{�i��t����*�M�: ���,��Ĭ��:��Qi��	'�Ŕg�Y�8����?!�K�IÐ�EmW�X����=�s�+��J
t�� �62�߬�z�e{WD^!�O�����'/�x6�C�D�A9}�H"c����\G�Q��8W;g���,�3�
���%��jP~���|*5͛�[���l�jo���q�@Cr��
��.9>�rk�?�lp�y�ozL��Ra�4,ᇶ��f=Y��#��g� �����q�g�� ��	l� ���,ݶ���c߉��J�b.V�]%�B׏X�9U(�c[��T���+$�������{Z&QA�ñB��:"��#k�r3!���D�%D�j�W�&L�=?n0u @RHo<�́2QJ�b��&��j�~��������f��
��t�����{ Z��Bָ a,Rä@��+��7u��+{��5��M� z���G���Q�,Ŭ�����-��y��CK3�q��ll�׫W�3p�6$�(@��%=XmL�fUDVo����h����Lc0�v�T�h20�%#b�$�N'��bH<9���, ڬ�1���n�E��&��P_-���xn�c�o##Xj��$8�ĩKr������:y�l�RԣMW_P����O��T��J+N�iA\�E ���*��B��1�HB6Zl � N�g�{��61�&�ZҾ��o<���a"Ȑ�d��Sw9q�o�M��YT!	P9��寀 �/�e}C1��gQ���q��D
�S���M��+��"���B?N��f��hq��v������S�贑Ǚ�H�>�H��i��h�
��d�!8�ЉR��7��|s~�.�z#<��r�f4s�ty����c��c�= ��!C�Y��9���U��y�fN�2ǀ1.i�������&�pj�������_NX��yG�"kv���1����N蒱e䔐��є��tC��r|rfQ�W5��+��*�4�{�3t<إHS=���7�'��$�ǧ�if�R^�"��]e���M��]�w~������e:�B�ܶJ��I���v�eS��*�ZK�y0�/~��AZm�S/�E"���_U��a�a�b�٘�w���v6�ݹ��R��\�v\�\�^~)�Ǚ�v�-���J�nxv�_�6���vGr�˕iU���r��P�zr��2�;'q_�"	D-\,�GKs
8�8�'�MNJ1_I �c������UZ�w�G}��&�g@]�#^!ⷪ |�<��ߞA��ڗg���*�*[/H��r��N>A�a�-�S��܃�gT#���=M��ŏE}����K���&C��os���0k<^,�7�H�� Fʷ1�,��.�C	еo���F�a(�ϋ`)�Ĩ׋F@�z�F��}��}�4�������w
��E�f��{�]�W��-�b�g��f�`��H��X���fW�"� �_1���ҧ\[N��fm>�n�pk����>m;��8�WA@�+��R��j�Z���T��Q�cJ�FtN��C�����-�m�6mAu�C �vi�1�C�W��/D� {r z�5-i�;�@ ���hs|�I��gr��+d�q$�� �֍km@0�� �0��Y���
�څ? ޻$������ ~��|CHG*��.���j� 0��̃�X& s(��b�� P ��� ���U�����\J�NR���o�k<�x6��d��P�g�}�gsج��!��Ǝ��$�� �'|���f8X+zY�9�y7uDk/@��"��P�X�ao�ș�� xְ��ޓ�{?�!>��u������� ������/2[U�xz�Yik=��5�k��L����ϗ?��P�%*['&_���֊�kC���,d8pVn���o�Ѣ�-����9|Q�6$;5�r�8���ͅn����������m&��1_����I���ޥ��xA"_�������A��qE{j)״�~%iρ6��=.��-��_r��O�ǯ[~栚r��a�gk��ۏ��жTuT�>�4]U�/�����Sj�- ���hJ1tN��9'*��?�+���%@P�.��{�m�P{b�q��V4��/���뙖����-m/7&%�s(���(�q~fJa�e�6�o�/b�HE^g�C��>C���~y�,Ŭʝ^.������4D+��^iK]w��t4�z��K�ٻ��V���7P�c�@��$R�E�F��Vq��CN�˒
A���`�
�oH��/TiLD�_H���q�w�iߖ����e�1`�K|��?sa�\�3=~�i.W���Z�Ř�	x�ɡ���"m<�^!��G󺪞�E��6[Ͳ���[�0�Rh.s� ��C�@�!ߎ������g�u�'R���R�E�K���z/B��=-7�bk����@�x�EVN��P�yT*�/О'���xuJ2�TJ�M����%����� �6��-�E��>ꮭ��B�N"ޝ�IvD�+_��}
ku۫�V"c�`eL2:�s��I$��x���<YXG4�W#�:�\�hcz��6F�<Z��x���A���We�D�;��1K����\�]+��ڥ儞3�Nށܰ�i��o;��x0:j��>�QxeKu;�G��N�Aذ�Q5��:�z�R8�LO�����Fb�    �1�Nx>�txw�[�Nb��x)ӕE�d(�,쯢�Mb��Q)s1A�⦈=D���wj���5:��<�}����HQP�Ԝ]��zx��ءw04�^+�:⺕O�$v�W�I�T�t��׫���إw�3=�tЕ�(cp�Nb��cFŀ��e�[�P�Vb����#��V�U;�������!������f]FPp�(#j�Z������M����;�1$���;�O͘Ǡ�rm�;׋�4���M
h~��U(�����j���>7϶a������i?�A��i��_���(���/��K�B�����#-��cչ�
�B���b&�+�!ex�/N��Xc�t��f��ꜙ�i���=��dE����}� �X��\�v�/y���D�_����m�|��a�:u�8����{�M�S/Ě�R0@�����s9�X���{��Jf�@���͘�H{
�1�Oi��3-%��wgFG�OH��R:����˭����˃�QŇ� d좂���t������xD�X�:t�8�Rh}��h=x�<����H+I��$������o� ��A��#�\i�2��h��$?��>j{
^�-m�k����u�[C\����t��'�.54!�����r��)0���R����\^T�����^(���)سwVl���z��^z�@{�$_+�l?��PӖv=��[�?S4vS� S�?�12���v����OP��$e�i�"��;�evY��Xs�t�k&�?;��Vw�?��2<�C9�,L@?gg������\*����A�R �xI�r��0<��be�A�lG�1_�occ����y�ٙ�j#-�6Ғ- ��>#�ZS<4�Z�����{�q1$�̰���SY�� J[��*�9#�g �0�~y1�1�R��-qA|'���ۺ����s[�^���`����?Q]l���OҙW���������т��뉰6�λ_�6Gc�ǣ� �\��i��H1�?[�/�m��K�ָhb�i�<��������h�G�U�2x���\�εS�8I7�b	�����4>�'��ޥT^��*�J9&���_R��N"19�'|���m����lj�u >�V�v}�-��Vrǉ��ǿ>I>w���C��A�3|������am"l[g_a�%�1HX����-���{j�����.?�����a��~Q�C�����N$>��4G #uF��k�ٸ�Z�
Ѽ+ �(L	f+�QYZ�v��R-��Wnϣ���#��Nq�m�7�K���'pt��D%�6���Ш���F<�	|���3T�z
���ԯv��:�D��w�~�S��d��4'h��h�C�X~���h�!�q;�d��qƄ����^���2�5Gc�\�%VY���)��|��F��yY�C�����j��c�� �7���$r�9�Jb��;�������7��
�kZ���ӌT��:>_��$7����#�t;�oƹ1�~b��_����Z)+�����:�k�|���$��If�zk�H�����\���D��b`���6ߩ�MHs�p01��U����J��x>�ͩ���p�/�N,|�;��֧y=��i)d�!3*ϸ��
������W�����e��R����Wt��싇F���+�Px��P�7τM����?�/T�'�V�S�Tj���GϖJ�M|�Fe���g��Zs.ao��L<�3��B��:��$���6t��;�گ�yn㱿�gW���{z 9���o㚸*��;1�:�֒m�`Z��<��ey���CR&�}jk��,-)�ae��ww,�C��+{�K||��Iz�@�����%5q�4���}�k�L-+��������_u�joRV�d`(@xb�7�*7��gM�������1��?�b��?��}{�"���~�Tf���H�?C�_���l₊�R�����G���o҅O�M��_�{�?@MϢ��9�5�O�;��b�h�埉K[�"��C-�����գ��2y�6q_��m�G�H���BE�X�SY/��cߌEzr�� �G������3�a_�V�r�>����	��[�����+HSV�[��CN߀�L��R_�Ծ\�O�b�Qg-g�J��1/D�^���J	����"
�����K����c�g�ISc�;n��ꋄ��K��j����6�Պ)� � �� ��6�8	\L�%�w$�A��,���ӡBb�Y	�PZ�%�g���Á~o�]��h���������+c��7����Q� �߄�{�q\�H���A��bm��� 0Q�	�;��� q�=�lP��G�X	a���@�u/�@�.�R.��
W�� `XW �P�jdC��D3O  i�N�ȑ�N��L�R��P�� �B�m�9E��
�`�4B a i�^�����w�͘0"w�� ~��;�EV$'�IP�4�n��w����L8G��Gv���B���HZ�������;����ĺ�la�L��<�Az��3��,d����|�@z��L!����� ��[���w�ݩ��!M�� W�x�݆���a0��88���Nc�,tceDl��|���[k����x='��󃮗�Z=W�JÄ&dM�e{羟�_��]F�vk���~Нo�BE���~��$>a|����Ze\�������67	�ހx�#�K�Q���z����
}��M��܎�}!{4����=��S�p��m���A�+ٔl�,�E�P`rxL��JN&T`�8�_<Qj'��ӆr�X���B�՚�#t]�\/"~{�]�=�\-�)�����8ov����n��6��6��L!���!0�{+�fAVJR��i�9���G0��T��->�0&.fl�@?��?6cnj��߄��Y��jV�t7�yN#�A�=�=>esm�� X� S�0dpH�!*��o�i6�W#�1O�<���3�b2<�.5tiW	�o02Y������<�8�C� ��kz���������߷�;�.^_�~�����
ގ��ɧ;�PR4�����V V�$g5��$��5�B��/��x׮�۳��n/e|Z (�f/`:iog�`dύ�lQS��F��l��s�p����nx8�Z{��C�?��8��{h�+/6�AnUF���� �;�������--���Ʊ���@�y�e�D>��	�Ļ���[[?/'�1 og��\�������Ϗ}�sh�T�6�����P��$@����ᒎ���0������߯W����(Ek��Z�c��r��i�,q���e����p����]Z��٩A��1OS�Y�P���J��K$��<��~ ��==յ����� B@7D��?�����������=r]�~H%o�5�u��ǡ�1���t�	:6�IL�}aiݢ�Q�4+rc����4�>�芍]x<ڠ����o8�Y���x�1��E:��V�ۦڅC���3�Sv�.��F���A�ý��{���t;�ޣv@�ԧ�]�n��nӥ"2u�xy���D��r�d�H <���;���h������e#O	�s��C_��ܺ3}+1p|�����U�S���CN�c����Ǹ�Ƌg�{1?�퓂)����k���[���h�D�PX�����X��*�p�ޜ�h�*�\�jA����a}�ƭ�1���֋6P��KoZ1�h��)�4��r��(�о��c��p�Gg�$©�@+W��M+Āu�b`�S�|��kI���j��i��mJ΢(��t�z:8��E�`��˫��6A�|��;0T�v��Q��}�e3ʷ>�ºi�c�z�n�`�e%ͥ!���H�@/W��mYę{p��Ţ�4�|�r5��|H��3�6:xxh�
��GgƜ2� $�3�{�[�봭�ǁI?�3lJ9�A��z�����f{�g���w����s�}��k�?�M����cBy�r-z���S�$
��.b�>J��9�ٞi��)n(�XK=�� S   'Ra��J,�<�����ϗ�{�+��|�����qu���o��AN��8�L��!x� ���}o�����_������      }   �  x���ٲ�h���|�z��`�cD�n�G�I��9'������v!^�!۵��{�󺹵���$�� ��K�����-b��g�h�=t�/'�+��$D�
�o�������B�À�-"��l�R#9 ��-*����IUO����T�� �}����LlPl�� 
�Z/е���7ul���{̊y�( ���a<�}x<�G�?�r�+yğ����+��d�'�8����m�3Z��
�@�d$2#���+�cI���ߋԡ��tk�lsb��b��^�oBSc��4-�y��m�j$BC�[�zzt�����$�ҲPh�L����6$a冹�O�I��Օ�]V�r�U��WZr���i�]���YK�N�
0 �ZZ��&P� �d�.��Z���!�
`Yu�7�ta�Ww3h��miӃ|$'t@���>*�����gu���yC O;��Ӝ�w��G��"��p^��[��� v������ЎM�iFU�H�A'��A	>Zj��.�L߂�L��"D�
�i){�ۗ: �����}N+�9)T�z�խ@hb:4Z���a���d�{���e�9�Oa��A�S���r�N����P|��~�R+�sZm�P��Cn��h �Q���H�%��zܤ����TmIF�� ��BK~>���,����3�Nq���u�����/4�*~ɺ2���*#�ȩS���L�:��Ĳ1z_P�5M�0��If���!�a�t�u1��!>��^��KM[�eG������B��W)����e�i`�Ii��\��ly�,`3>�k���-��r̻ӭ�K����I~� ^�F�4>��Yq�D��/�0"�!�Tޭ���I:T9`���B�"��ީ����QE 	4P�d�pNB�L	��#�ZTH�o�ɛ��i:d�Vg�/���=��x�6�I��O����\� ;��b9��\� /pQM�=Nr�$.������$<�𼭠2��>�^��d���K@r�,F�� wy�v� S��=��A��4O5�������l/� �74��Gf!�*���V��^=i��܃C�cݶ�vU�P�P]�[�p�@"};�G�{��j���̟�����@�>��Գtc��$^�1u� ~����g����ZJ�|f�/{��m�	�ޠ/L8�z��iN�g�.�x߅u�23�'"�p���
.��Zk�r��S�)�[j̼Y &q��J�hsL�ի�A�Y�v��'v�"�p��=]��ǌ�}j�Gh�-ß	��=�7�����<q�j*� xU�Q
�wk`�.�:��1{N����<ૃ���9FL��=�r����P����y�,��ϭY��P���"�%ge��k�qBsQ�����0��r���b���Y����}p�������'s,Y��*o�A�{����ͧ�I��`W��|�5n6k�y#|lBwl�ES���-�v�����!Ɣ~>4���1� k���qs�2!kN��O�
�}�X�˔���&H������5�h1tU���x�S�1��8�9���Q"0{'
&�d;�g��V<$:ﻏS�饇�fk��?dbN�F.s+�̭zcZ�����=Ǖ3��x���"� k@Czao�޽��8)pc<��':6FO�.�_�#�.w�Zm|�"}]3d*Uz�Mܵǰ��w��JG	���< �I�1*�${b�C���������������}��`�i���\�h4�����@.���0}��pH��9��iX
M��QӸ^�ew��]��nFY"�R;8����|_�'��r��Bm\�8O�}=O�/[��:��/��t9(Ba����⭰���O<�wlԵ�"��?�(�u;&?�z�{Iƾa��ˌ���d�3����t��L"v��ʽ�����f@�����ATw�F� :7��~]��f�H}]���X^�,t�h�����E?��#_�:h�ktɷ?~����? ,}+a      �      x������ � �      �      x������ � �      ~      x���I��Ȳ�q�s  ��Xw�" �����w�Ɲ��&���t������[�S��L�,������??���@�ǒ8��uc�&%ƀM(�1���ZN����� 6��qa8)߇�-{�f�	�n�ȿO����E�&u������]buݻ�M(�T��h揝��	�2Oj%�j��}k�z�&[ӫK5���n� �P�h2��\�/?�]؄b_q���L��
��} �X��[�W.�.��*�&��9_
���੦�M(����;��d�bsP �P,�.\��6������	Ů^Z˯�vw�v�$ 6�X7N4��ۻR�-��	��5}�t"cu�2jV ��p���7���?lR3��کayc2�?M�&K���1�ʒ]����z�"3��Z��h6���6�ۇ���|D�&[Dԫy��{�I
� lB��ZYK٭"��׳ŀM(V]��Sy����SE�I]��x�ڸ[j�+`�]vL�s'Ɯ�	�+�M���n�{o[�xR�ؤ�m����/e��`����~>~�ؤ�|��7�������6�h�u���+�ҧ�	��oU����.���6�؇�;D\��$J��	������8n9^� �P�~��.EFi/�%�&5\��~o���'�,�o�&��Ҝe����9�� ��Ѯ'��b.��]/lRM��OS�l���5`��#v�<�]��6�����p� 5N�oZ5`���jR�kns<��ؤ�sj}�
u���]�&5�=(��%�\��_ ���>�q��伷��lR{������hIr�ԀM(V��>���>4��؄b�ӻ���)���؄b���<�z�θ�M(V���.��Ⲿۛ`�Ms�Z��%<�e�O ���X��q�r�i�e�	�f�̛�F���	��	�-U��co7�c�Z�&5J�,#���E�>��M�s|��KrN�����ؤvX�>z��+�^�R�T{�N�Ȧ3s��Is�Pl��wWv^���1�4`�������.Ng�[6���5Ez��}��)/�Im�k��ў�|%��Im�T���K��.�7�&5�ݧ?�S�P0eslB�J���<�k �W�M�������~6�M�����ǻ�,����M(6v�Խ�_�s���&k���W��յf6�H�:'��W����I=@{�k�Gk�L�s7�&۬��r]�f�Ηu ؄b���Z��ү�S �T�x���q�������M(���g~��L-�ݪlB�-�ؙ��j,S��	�N�u|��A�W~�6�_�?T���0r�ؤv��������ݲ*}lB��y���/+6o�nlB��t��>>���9�M(�:�k�f3{]��ؤ����D�����OV6��u�����L�O�3`��a���wI�/C{r�P�Z�\�|��kv1`�jj���mvQ2�ٞ� �P�����O����6��m����g<���'�&��ʛ-�~G"k��ؤ��Cee�I,>�fp ��&²�)S�%���,`�z��u�������C�6�n��{i���4uؤ�[��nIt��+�l�&�м�#qچ��+`����Ώ�g��e�=`��I��jSqs���� ؤ��O�(ޭ��p�^{�&��z�諶�>�ۦ ��VgyR��S{��5`�zW��e�5s��$�	�z��v�pY?���w�Mj��y����hIv�?�Mj��*���5sq�m�-`�Z��W?�[q�ކb6�-#�)�%��ٸ)=�&5&�qӘ򎾺��lB��%��G���!�w�	Ş|�)#��s�u�&���X�YK/�W��lB�\����Q�i��<`��D�?�1�F[ƻ�v lRM�.��r��韙���
���<��K�}X�	���/��t���E�MjU@o=�ӎ����`��V���n%�y��`�ڗz]N�![q�]u�`���O����q`���6�^j)��=����0:`��K���NYqX���Im���|\27��[6���08zp?T��c�
�IM|�M��,j��Mj��}+�G�;Q��6����.��U��U�`�ݜ�4c\�l��f�&u��
g���${q�M�$3�i�>�َ+�&���~<M�����{6�؃��g}ue��=^�Mj�eMqyn��QM�� lRS��]��|��GR�M(V^��"��io��lB��"ݖ�r���bGlB���<Jn�>��Y��Mj�u�ˎ:���<��
�I�~Z߆H^Lx,x� lR��hw=�]g����6�����ys�T_��&�"�&���YQ�Sؤ&���0��ɗ���-`��?�*V������6�ا��o6�fY�ؤ J�޷"dK/1��&5&uw�D���oJ� 6��͉�S�|�^r�%�&���.�^׾b��I-Fr��-y%Ցq
�&5Ji�ٸ�G�]���6�W�<������+�&�S�g��������`����C���ٸI�&�A�O�HB^���lR��m����E�R�&� e��I]�5r�V� 6�V�W~'�<�2B�&����In���@_��I-F�Yk�'�c�Mj��?7:ac��<m �P�{m^��x�7Fhk�&[y��\��L�6�k�Mez5���YIF6���7޻/�VO`��G;g��V���(!`��2ٴ��6��J��O�&5J�S����.��u��P�.i�J!zϵ؄b����.y5}�:�&;�M�p�6\���5�&��7���-�K����؄b���ǐߤ�>��&���w']�$�B6���nO�sx�d�ؤf�Zrm^�,���lB�%E�I+t���
؄b�|w�'�I�_�)� �T�����J�L��lB�E�dmy�m�`��-`�Z��ú��Z��{ lB���P_��_�(���P�ulG�ޜ��R��IM|�g~,ܷ�*wm6��`�\��	Ք3�	��z��i�L��> 6��U�љ�<�ƿ 6�e��_G�����3`�UO�6t&���sf6��q��8sߺ*�O�I5��`���O�PSslB���U$����q?�,`���Y�~�1���4��Pl��oͰ�������v��]2��%Ѷ�ڀM(6�yҩLƮ���c �T/�ɝg��EpػؤV�o�����I�b�&����l^��e���	�	ŎEC�����j���M���>zn�gі��lR�����S��U�xlRc�Z>˸`;mlR��ײ��읅�`���+ۢ��N��TS�u°��!���ؤ���\#0�=I.T�����u�n�e��DlB���fg;�Ҩ��3`�Z�;SZ��3�I��Mj�ͺ~�s��gVԀM���匤���6�M(֜�7J���Z-���I�@o��F�]B����I�R�'�����n�#�&���x�֮��	ؤ��856]8�CTe��I�
���8��;)o��ؤZ��R�q����`���������K�� �Pl�m΋pHRm=og�&� E�9����:]��`�:�g�O[NJ��Uy6�X�������.7�&�\��⦕� 6�������@ߗ)mn7�&5��z~��*[yV���XA\};L��aSO�����Y0�	_�&'�#[�;.��r���߷���K��*R�����ߧ���2p��Ц��� �g�k��
>WO�gE���~�> �g�+��N��u[�燼Q��(���.z�}��M�������4^��%��kP���a�+�42\ؿ��Xv���ˌ�iy�}�.>�ϒ���!Wg�7ef�*��۴���s��߃���%��v-Xg��?Kf��X��3�n5���]d����Wr���*8���'`��\'W�C��(N��`�,Y�r���MӃdz��4���\^�~��`4.�zo���P�Mj��1;�>$ֹ.(� ��<�{s���މ=h�n��扼xm?�]����6�Iُ��e����lr�u����ܛ�w+�/���P�*9��l�g��w��ܤ���O��I��턳 �w��wl�M����u*���}M}��B���M����.��x��ՋZ�n��M(��ni�����w�6��    �.ɴؒ�;Ʌ>j�M*�h"Ji}���}�7�M�4���|-|��ǝ8ڀM�p_�9�`7ĕ�s�&t�m�s�M~x��� ��������O���CoY�0����A�$/�]�:q{��O�؀MVLee�6��]%��b�}��Q��|?���'`�]}Rg���2��_]4;J��7�xIt��
�M�\�P�O��~����I}��������_��jo2B�%���L��ɱ1;Aw�/��ZI`�����G�o��f47rd�����_���9������l2U�������_�K,Ăl2����~υv0״��ig��6�� -�ܹ�C�.)�ߋ[�^�tm��5*�U��ۂ��-��s��+koy�> ;1X�M'��z���GU��W��<_GgV�/�&S-~４F��
�EL?5��������%��ikE��I���f��CR�ۏ�-+�&Ցm��Ckѽ,l���lBٕ�l�b���M�?lR�k����^������T��a�SRf7��	�fc'{��N��z�`�:\Ql�r����u�S�&����=�W�J��rb ��i~8Nz�{w�D. �P������_5��s�
�I}*a����<��ؿk�Ж&[���)Vr 8��?���ۗ#���.�^ls?=
��a2�=-�t�j�j�Õ�g���6��,��+��u�)���G�C�c��|�6�v�T�>v ��m�=/�^N�>��9lB�qo.��rm�YnW�&�j�[5�pO�O6�XS�]�yLyi�J�lR׶��W5��ϺNJ�N��b��Μ=��j��3�Uĥ-vN����W?��uڊ;�vnÍ���*��>���r甑����Y���*�]�+������{���*��;�;���.��q��7Uh�)����	*���*�۵ݭ���ɴ���*���r�Z��~�w 7S@��斉܋����X	߫cJ��5zc�Q��!�������IS��jwi���9*`�n����xפ�U�����P����X٥���	؄bU׶?��9U��M�h�!��ﶗ'�]�&{�_�6w�ہ�;�lB�)�u��./ʴ�o#`��C�Z�c/��i�&�t��/v8$�`�}��a�D+��0L>6��2����>�J���	�	��Q�y��A區M(v�N������j�P�Aۿ����,��`�]D7�8�[�)kk�&�6S�7�Z��L��E!�9؄fc��d:�h�;.<��՘�L��y��xw����Ua�eO�&���9[�6��u9>��g�&tE��vZ��]�t��^lBoЧ��:���.�(nP�`z�H}w��z7���N�cd82`'m�8��'�����*���J�וj���t�����{��:�g�IW��5�ͻ~�r�/��lRݎ��r/���C؄b/�Nx�>K�ͨ*`������t؜�+`�nK�P�|z�ӘP���6�1�����}�c���SqpkY�Gi2'`�E۩0�S[�ΥLj����x��"X�}Km����}���sԋq�h�΃���tδA*���}���H�j�x�W�����^���4{�&�N�L�ߟl��/?[��ndK[n�޺�/�	ؤ��|�.�Uu���`�Z��GU�y|�u�6�%�u�W>.�xnW�M(6{�LG�kI3�L��P�ױ�؃r�6���	�ν[�.��V��|؄b�z��c9��[�f!`�:ɔ+���&�]�$����L�?��z|���Q��ؠ1������c �QC�;f��0�AU�������eQ�
#����	�����Bϳ�mƀM(���5�3��<�� lB��1������}�	���I꛿���E��P�!:٣^��pv�`�:Z��ްNG�t`�-=���nr}�P,�����ҡx���Z�L���e�O)��Vs'��;ݚz�9`�E/m|xY0������׬y���w�~?�Dj`��g�hc�O]��/j�G]|g��P6y�_�`r��{�ѕG|mO����E ��(��tG�^���5��j�B0P��>���5d<�[��^r'�ր�5+y���r�n�φ섻�,����i�HT�>�� �K섿��������{C�~(ZE�	�����8jl*�|if�P�c�_�`8�N��i͔�,���¤�"g�<z�b��_Ԡ�i�\.�sJ��2�_ԐN�g9�y��g���)�V���g�����vwZ����&��"�[�~�� ���QC��lW��ñ;��Q�zj����]y�Ѐ�5�朤;Ɖ����_�pd�<��k�m����rz0��Vc��!�͸����]^>����4�>ܣ̱W�m�`��S+�T��u1�~�V]��f	��ȭJǹ���5�.�Q��메Χ쿨aL�>����_Y����|-�Q�O�.����e�Mh�����*��[��2 ��^¥˖�%�x4�`s��:�����tK�2�_'�Lv��q2`��(p{�Wn	|��DU� �/΃-�܃�d�p:�6�;���&�Q�h�;�lRw�KfY*<K��؄>e�����~��ͅ]a.���=J�i���"��d�_|�Ê�<<?ڌ�x�� ���x��ߌbg!����	�Z���H[�G�}��{o﮳��J��jπ㿫0����.�a��6����:�0��=�U=�|؄.�����Em7�;�	�f!U������Q�i�&��"叞-^6�^��&��B�}�J�L�6�X�f̩�齾N�dlB��AН��RV	ؤ��饞�vϒ-���	�.Y�́o�W��#
�	����8�v���|�΀M(V�LPW�6���9lR�'�x�>=�7�&�VO���٧����!`�Ud˜���D�諀M(���xs3����lB��gb�ǆ��g�y2 �Pl�&���Φ7t�ؤ��gfW1�S�`�u/�����6����P���}ٳ��cN`��6'�Q�N#�M�&u��b����e�\r�M(V�Hִ�Lc
�g�P,�{;�YLq��BlR��٦�EoF�3�S�lB�s�O�>�w���,U�
}����������d�`�ף�޾��-�fRi	`�v��s�r���ؤ>]t�me�4�T�6�Xf=)�r6%y�`��]�����Z��ؤv�7�L���r��G�&�l�^�!-:l�� �P�:]�V�N��M�؄bUz�ݿ���l�#`��� {T�A����� 6�ؠ޽���w��TW�&�9��-7��^ʅ� �Դ'�ӫ�[�ܛ؄b�luw��������(?ާN7}���{�&�f�iw	���i�\� 6�Q*6���S���lR���r�	5u(6k�Im�5��u�i���dJ �g�4-|�.Uݲ<.^)���;�ϒ��{��}����%��=`��g;�:e��B�Y�M�\;�b�j�L'1�&�lW���~}֔ �\�s^��e7����e��WA�������t$�&v���;��Z��J�%�&w�]5�����Tq��`;d���]=YԆw���U�;]��˅�Mwlr�;�4���6��o����Ų�,�LI�e+�.`�Eڼ��:9��W4Ԁ��+����p�3�]8�>����6����B�T�N�����˳�nS�y�g�Q�M,xG�<��V���a ��h�'����W�o���ς���מE3|k���b�`�,���X|ne�6$Z���lb�x*<I���du��&�m�y��kmS^��ؿ�����x�����f�����ww�����۴�k�|�g7+ �X�S*��!Y�jؿF��@��_�]IJ�I �w���GLr�
�����I���M�+k�f�s��9ݵ`�,���%:n�J"n���/-`��#Z�?�s3(�������_�	ؿ3i�q��y{ۦ��{��hؿK�(��k�3��(��5�m��ݨ��}�9����Ɩw!`���b��k5���'�z�ӟ�,|�N�%��ۖ�v;<�-`��y����X�PB�)7`�:�i��WE%׻���I�X�-֞�22U&;   �&u��'��A��]M��ݰ�����J�?�ތ�M�x?e�ś�<�}�L��������j��8k7�E����G\��=է|zRg����y�W��+��ƌq�t+�lRW�!���|�?δ.��I��S�Gf'_��.F`����>�kM޹�"3v+�7	�ߊ��{�n�g�t©lR#ǴԼ�i����O���&CI�U�.���쿩��eQ=���|�olR�'Ge�]���������ߜ7
�I��*�jI��w۰���C�1��!u0��ݓ�~�1b�[M�X�{h�M,x�W��Y֗�(:�ؤƜ�8E��K�oaU6������O+�zk)�6��墽JɅ���G��u�Ȥ���-XJp�@�߯ �I�G+����W]�k�I�>�z�;q����� ����q���1��[�}��I�*����O�z�\/J9 ����_�Ĭ۽w��|u�{ؤ������_�/OOSJlR�ѝ�����3��z�&�#%�p�<&�wk��M*���?�����n�@      �      x������ � �      �      x������ � �         V  x���Ks�@�����*��E(��,��->C�5�DD�ȯ�F1FC&�XV]������sO�i���f�ڂ��(�">�������}�<�ȶ[�:0���u�ǞQikpG%c�����Tv��/��[;��߀j2"�Ue����W�-�4�}�i�1@
"�
������N!�cd���⒫�3�UǷ�wc�I`��D�8C�}���8Q#�����޾����+�c�veر��3<�2Lz�����Z��q�1	b�(:D�5.AUW�]~�_3O�J%x����2Z}�y!�fy�]O�Nۓ`R�ܱc�;��k+u,���&�ڼ��Ɉ�N��q�h!���{/�j�_YG�a��X��V]��v�&t=��:��z2]!��˅G�ɪ��yjF����s��	F�Ƙn�>d��d�dM0ʠ��d��Oe�u�a7��2���Nzv+9 ��	_�EGJǘ{�=�O���0.ӯ��.�/��n_�,�k;<��	���F0":Q�k�!�	�z�TU&�)�0���Pŋ�YsRp۴d�g��z���&3���w�_7q٬.'n@r20fj�>�8�	!��f�0�c�e��Ifj|S���8f�[�p(���[<>����ۯ�ΊD r���S͈%f��o����~��'v�B��ISt*�]�~�f��.l���b�?����Z�?���|�p$3���G�05˂��e���)L}����-�|����j�7D�5G����L���vzF��}$4�?��1Օ<H�_�����$v�|�u��Bl��ر���M7�/�"�vº��/�������*<?��J�󃄏t������T*���+�      �   �   x�����0����)|�m)�vG�4M�ٰqh�P|z�Ƴ�W�돉碿Y͝\�2��I
�їݭ�.���i���6Ib����1P����M�[���I0�+�y��	w��%��jao�-�NZg�cƮ�3��6~���N�s8+f�4_6�a���[��%��p�A�o����P�Ǝچa� Ix      �   k  x��Vے�@|Ư�Ě.����DQ����������&)ٔ�}�j��{����Fo�^�t��d�!��, ����h)`6�Гr�%s͎l�N���L����zp]d� ����@�	�b�ϻ �;�C�R=�z�+���=��""gΜ��D.S�b^?G&S޺"�S�� �kz`��8�O3��N�߸9�����]\£F,���`�}s�,flnk�f!(y�
�f#�®�@�Z�=L~���'g#~~���y�R�0��	qx�㥖~M��&է
T1?A4�/�x�Y�7�`{$S����)�}�b�&�X��<Vм�3:֧�o�߄������n���6݅ת�:��"gj<�ũ>0�Ӈ�MI���h���(Lw����r.����,��vק� <�v։���	M�A�"xnU�G�`��˪f`g�Y�X�t����R�����`���?g��b �3
1S�X��$�_����̷�BP���`��;�N��71���V��J{�<�l��S��G×#��xZ�<�1�td���p?���b�r�K�Kq`��X�r�O�/q�m���n�R��rDglL������^ҍ&9|���(�j�.Y�z��Vѐ̚H��m$@��}ƖK�$SH�����p�6�S/rkL�j��b�f`Dtn�4�����QR"�m¤��Zl��z��8�������R���F��1��4ѱ.��1xJXܝ�a܄	���lyI"�y-���d��.�g�1�;�����q�U��Ci�F�~���]��Y��v.�BO�ÈbR�����K�������._�~��[�U]ê�s����O�?���u��֤�M]����t:?dv"      �   �   x�u�K�0 ���^ 2[��F����7��)���^��w�רo��\�"w����ew�KM������2y������_P�]����q��n#hp�P#9#t,�A�  �%�|e3�"�'��:
C��;��m����5��s�.��?0���Ar8�b�1�F�58      �   `   x�+53�.,(5���,L�Lq/�*�)H5�3�KO�4�3 ��t�2KO�����N##]C]#C+c+c�?N�����=... ���     