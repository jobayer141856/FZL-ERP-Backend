import { Router } from 'express';
import * as batchOperations from './query/batch.js';
import * as batchEntryOperations from './query/batch_entry.js';
import * as batchProductionOperations from './query/batch_production.js';
import * as dyedTapeTransactionOperations from './query/dyed_tape_transaction.js';
import * as dyedTapeTransactionFromStockOperations from './query/dyed_tape_transaction_from_stock.js';
import * as dyingBatchOperations from './query/dying_batch.js';
import * as dyingBatchEntryOperations from './query/dying_batch_entry.js';
import * as materialTrxAgainstOrderOperations from './query/material_trx_against_order_description.js';
import * as multiColorDashboardOperations from './query/multi_color_dashboard.js';
import * as orderDescriptionOperations from './query/order_description.js';
import * as orderEntryOperations from './query/order_entry.js';
import * as orderInfoOperations from './query/order_info.js';
import * as planningOperations from './query/planning.js';
import * as planningEntryOperations from './query/planning_entry.js';
import * as sfgOperations from './query/sfg.js';
import * as sfgProductionOperations from './query/sfg_production.js';
import * as sfgTransactionOperations from './query/sfg_transaction.js';
import * as tapeCoilOperations from './query/tape_coil.js';
import * as tapeCoilProductionOperations from './query/tape_coil_production.js';
import * as tapeCoilRequiredOperations from './query/tape_coil_required.js';
import * as tapeCoilToDyeingOperations from './query/tape_coil_to_dyeing.js';
import * as tapeTrxOperations from './query/tape_trx.js';
import * as multiColorTapeReceiveOperations from './query/multi_color_tape_receive.js';

const zipperRouter = Router();

// --------------------- ORDER INFO ROUTES ---------------------

zipperRouter.get('/order-info', orderInfoOperations.selectAll);
zipperRouter.get(
	'/order-info/:uuid',
	// validateUuidParam(),
	orderInfoOperations.select
);
zipperRouter.post('/order-info', orderInfoOperations.insert);
zipperRouter.put('/order-info/:uuid', orderInfoOperations.update);
zipperRouter.delete(
	'/order-info/:uuid',
	// validateUuidParam(),
	orderInfoOperations.remove
);
zipperRouter.get('/order/details', orderInfoOperations.getOrderDetails);
zipperRouter.get(
	'/order/details/by/:own_uuid',
	orderInfoOperations.getOrderDetailsByOwnUuid
);
zipperRouter.put(
	'/order-info/print-in/update/by/:uuid',
	orderInfoOperations.updatePrintIn
);

// --------------------- ORDER DESCRIPTION ROUTES ---------------------

zipperRouter.get('/order-description', orderDescriptionOperations.selectAll);
zipperRouter.get(
	'/order-description/:uuid',
	// validateUuidParam(),
	orderDescriptionOperations.select
);
zipperRouter.post('/order-description', orderDescriptionOperations.insert);
zipperRouter.put('/order-description/:uuid', orderDescriptionOperations.update);
zipperRouter.delete(
	'/order-description/:uuid',
	// validateUuidParam(),
	orderDescriptionOperations.remove
);
zipperRouter.get(
	'/order/description/full/uuid/by/:order_description_uuid',
	orderDescriptionOperations.selectOrderDescriptionFullByOrderDescriptionUuid
);
zipperRouter.get(
	'/order/details/single-order/by/:order_description_uuid/UUID',
	orderDescriptionOperations.selectOrderDescriptionUuidToGetOrderDescriptionAndOrderEntry
);
zipperRouter.get(
	'/order/details/single-order/by/:order_number',
	orderDescriptionOperations.selectOrderNumberToGetOrderDescriptionAndOrderEntry
);
zipperRouter.put(
	'/order/description/update/by/:tape_coil_uuid',
	orderDescriptionOperations.updateOrderDescriptionByTapeCoil
);

// --------------------- ORDER ENTRY ROUTES ---------------------

zipperRouter.get('/order-entry', orderEntryOperations.selectAll);
zipperRouter.get('/order-entry/:uuid', orderEntryOperations.select);
zipperRouter.post('/order-entry', orderEntryOperations.insert);
zipperRouter.put('/order-entry/:uuid', orderEntryOperations.update);
zipperRouter.delete('/order-entry/:uuid', orderEntryOperations.remove);
zipperRouter.get(
	'/order/entry/full/uuid/by/:order_description_uuid',
	orderEntryOperations.selectOrderEntryFullByOrderDescriptionUuid
);

// --------------------- SFG ROUTES ---------------------

zipperRouter.get('/sfg', sfgOperations.selectAll);
zipperRouter.get('/sfg/:uuid', sfgOperations.select);
zipperRouter.post('/sfg', sfgOperations.insert);
zipperRouter.put('/sfg/:uuid', sfgOperations.update);
zipperRouter.delete('/sfg/:uuid', sfgOperations.remove);
zipperRouter.get('/sfg-swatch', sfgOperations.selectSwatchInfo);
zipperRouter.put('/sfg-swatch/:uuid', sfgOperations.updateSwatchBySfgUuid);
zipperRouter.get('/sfg/by/:section', sfgOperations.selectSfgBySection);

// --------------------- SFG PRODUCTION ROUTES ---------------------

zipperRouter.get('/sfg-production', sfgProductionOperations.selectAll);
zipperRouter.get(
	'/sfg-production/:uuid',
	// validateUuidParam(),
	sfgProductionOperations.select
);
zipperRouter.post('/sfg-production', sfgProductionOperations.insert);
zipperRouter.put('/sfg-production/:uuid', sfgProductionOperations.update);
zipperRouter.delete(
	'/sfg-production/:uuid',
	// validateUuidParam(),
	sfgProductionOperations.remove
);
zipperRouter.get(
	'/sfg-production/by/:section',
	sfgProductionOperations.selectBySection
);

// --------------------- SFG TRANSACTION ROUTES ---------------------

zipperRouter.get('/sfg-transaction', sfgTransactionOperations.selectAll);
zipperRouter.get(
	'/sfg-transaction/:uuid',
	// validateUuidParam(),
	sfgTransactionOperations.select
);
zipperRouter.post('/sfg-transaction', sfgTransactionOperations.insert);
zipperRouter.put('/sfg-transaction/:uuid', sfgTransactionOperations.update);
zipperRouter.delete(
	'/sfg-transaction/:uuid',
	// validateUuidParam(),
	sfgTransactionOperations.remove
);
zipperRouter.get(
	'/sfg-transaction/by/:trx_from',
	// validateUuidParam(),
	sfgTransactionOperations.selectByTrxFrom
);

// --------------------- DYED TAPE TRANSACTION ROUTES ---------------------

zipperRouter.get(
	'/dyed-tape-transaction',
	dyedTapeTransactionOperations.selectAll
);

zipperRouter.get(
	'/dyed-tape-transaction/:uuid',
	dyedTapeTransactionOperations.select
);

zipperRouter.post(
	'/dyed-tape-transaction',
	dyedTapeTransactionOperations.insert
);

zipperRouter.put(
	'/dyed-tape-transaction/:uuid',
	dyedTapeTransactionOperations.update
);

zipperRouter.delete(
	'/dyed-tape-transaction/:uuid',
	dyedTapeTransactionOperations.remove
);

zipperRouter.get(
	'/dyed-tape-transaction/by/:item_name',
	dyedTapeTransactionOperations.selectDyedTapeTransactionBySection
);

// --------------------- DYED TAPE TRANSACTION FROM STOCK ROUTES ---------------------

zipperRouter.get(
	'/dyed-tape-transaction-from-stock',
	dyedTapeTransactionFromStockOperations.selectAll
);

zipperRouter.get(
	'/dyed-tape-transaction-from-stock/:uuid',
	dyedTapeTransactionFromStockOperations.select
);

zipperRouter.post(
	'/dyed-tape-transaction-from-stock',
	dyedTapeTransactionFromStockOperations.insert
);

zipperRouter.put(
	'/dyed-tape-transaction-from-stock/:uuid',
	dyedTapeTransactionFromStockOperations.update
);

zipperRouter.delete(
	'/dyed-tape-transaction-from-stock/:uuid',
	dyedTapeTransactionFromStockOperations.remove
);

// --------------------- BATCH ROUTES ---------------------

zipperRouter.get('/batch', batchOperations.selectAll);
zipperRouter.get('/batch/:uuid', batchOperations.select);
zipperRouter.post('/batch', batchOperations.insert);
zipperRouter.put('/batch/:uuid', batchOperations.update);
zipperRouter.delete(
	'/batch/:uuid',
	// validateUuidParam(),
	batchOperations.remove
);
zipperRouter.get(
	'/batch-details/:batch_uuid',
	batchOperations.selectBatchDetailsByBatchUuid
);

// --------------------- BATCH ENTRY ROUTES ---------------------

zipperRouter.get('/batch-entry', batchEntryOperations.selectAll);
zipperRouter.get(
	'/batch-entry/:uuid',
	// validateUuidParam(),
	batchEntryOperations.select
);
zipperRouter.post('/batch-entry', batchEntryOperations.insert);
zipperRouter.put('/batch-entry/:uuid', batchEntryOperations.update);
zipperRouter.delete(
	'/batch-entry/:uuid',
	// validateUuidParam(),
	batchEntryOperations.remove
);
zipperRouter.get(
	'/batch-entry/by/batch-uuid/:batch_uuid',
	batchEntryOperations.selectBatchEntryByBatchUuid
);
zipperRouter.get(
	'/order-batch',
	batchEntryOperations.getOrderDetailsForBatchEntry
);

// --------------------- DYING BATCH ROUTES ---------------------

zipperRouter.get('/dying-batch', dyingBatchOperations.selectAll);
zipperRouter.get(
	'/dying-batch/:uuid',
	// validateUuidParam(),
	dyingBatchOperations.select
);
zipperRouter.post('/dying-batch', dyingBatchOperations.insert);
zipperRouter.put('/dying-batch/:uuid', dyingBatchOperations.update);
zipperRouter.delete(
	'/dying-batch/:uuid',
	// validateUuidParam(),
	dyingBatchOperations.remove
);

// --------------------- DYING BATCH ENTRY ROUTES ---------------------

zipperRouter.get('/dying-batch-entry', dyingBatchEntryOperations.selectAll);
zipperRouter.get(
	'/dying-batch-entry/:uuid',
	// validateUuidParam(),
	dyingBatchEntryOperations.select
);
zipperRouter.post('/dying-batch-entry', dyingBatchEntryOperations.insert);
zipperRouter.put('/dying-batch-entry/:uuid', dyingBatchEntryOperations.update);
zipperRouter.delete(
	'/dying-batch-entry/:uuid',
	// validateUuidParam(),
	dyingBatchEntryOperations.remove
);

// --------------------- TAPE COIL ROUTES ---------------------

zipperRouter.get('/tape-coil', tapeCoilOperations.selectAll);
zipperRouter.get(
	'/tape-coil/:uuid',
	// validateUuidParam(),
	tapeCoilOperations.select
);
zipperRouter.post('/tape-coil', tapeCoilOperations.insert);
zipperRouter.put('/tape-coil/:uuid', tapeCoilOperations.update);
zipperRouter.delete(
	'/tape-coil/:uuid',
	// validateUuidParam(),
	tapeCoilOperations.remove
);
zipperRouter.get('/tape-coil/by/nylon', tapeCoilOperations.selectByNylon);

// --------------------- TAPE COIL PRODUCTION ROUTES ---------------------

zipperRouter.get(
	'/tape-coil-production',
	tapeCoilProductionOperations.selectAll
);
zipperRouter.get(
	'/tape-coil-production/:uuid',
	// validateUuidParam(),
	tapeCoilProductionOperations.select
);
zipperRouter.post('/tape-coil-production', tapeCoilProductionOperations.insert);
zipperRouter.put(
	'/tape-coil-production/:uuid',
	tapeCoilProductionOperations.update
);
zipperRouter.delete(
	'/tape-coil-production/:uuid',
	// validateUuidParam(),
	tapeCoilProductionOperations.remove
);
zipperRouter.get(
	'/tape-coil-production/by/:section',
	tapeCoilProductionOperations.selectTapeCoilProductionBySection
);

// --------------------- TAPE TO COIL ROUTES ---------------------

zipperRouter.get('/tape-trx', tapeTrxOperations.selectAll);
zipperRouter.get(
	'/tape-trx/:uuid',
	// validateUuidParam(),
	tapeTrxOperations.select
);
zipperRouter.post('/tape-trx', tapeTrxOperations.insert);
zipperRouter.put('/tape-trx/:uuid', tapeTrxOperations.update);
zipperRouter.delete(
	'/tape-trx/:uuid',
	// validateUuidParam(),
	tapeTrxOperations.remove
);
zipperRouter.get(
	'/tape-trx/by/:section',
	// validateUuidParam(),
	tapeTrxOperations.selectBySection
);

// --------------------- TAPE COIL REQUIRED ROUTES ---------------------

zipperRouter.get('/tape-coil-required', tapeCoilRequiredOperations.selectAll);
zipperRouter.get(
	'/tape-coil-required/:uuid',
	tapeCoilRequiredOperations.select
);
zipperRouter.post('/tape-coil-required', tapeCoilRequiredOperations.insert);
zipperRouter.put(
	'/tape-coil-required/:uuid',
	tapeCoilRequiredOperations.update
);
zipperRouter.delete(
	'/tape-coil-required/:uuid',
	tapeCoilRequiredOperations.remove
);

// --------------------- PlANNING ROUTES ---------------------
zipperRouter.get('/planning', planningOperations.selectAll);
zipperRouter.get('/planning/:week', planningOperations.select);
zipperRouter.post('/planning', planningOperations.insert);
zipperRouter.put('/planning/:week', planningOperations.update);
zipperRouter.delete('/planning/:week', planningOperations.remove);
zipperRouter.get(
	'/planning/by/:planning_week',
	planningOperations.selectPlanningByPlanningWeek
);
zipperRouter.get(
	'/planning-details/by/:planning_week',
	planningOperations.selectPlanningAndPlanningEntryByPlanningWeek
);

// --------------------- PlANNING ---------------------
zipperRouter.get('/planning-entry', planningEntryOperations.selectAll);
zipperRouter.get('/planning-entry/:uuid', planningEntryOperations.select);
zipperRouter.post('/planning-entry', planningEntryOperations.insert);
zipperRouter.put('/planning-entry/:uuid', planningEntryOperations.update);
zipperRouter.delete('/planning-entry/:uuid', planningEntryOperations.remove);
zipperRouter.get(
	'/planning-entry/by/:planning_week',
	planningEntryOperations.selectPlanningEntryByPlanningWeek
);
zipperRouter.get(
	'/order-planning',
	planningEntryOperations.getOrderDetailsForPlanningEntry
);
zipperRouter.post(
	'/planning-entry/for/factory',
	planningEntryOperations.insertOrUpdatePlanningEntryByFactory
);

// --------------------- material trx against order ---------------------
zipperRouter.get(
	'/material-trx-against-order',
	materialTrxAgainstOrderOperations.selectAll
);
zipperRouter.get(
	'/material-trx-against-order/:uuid',
	materialTrxAgainstOrderOperations.select
);
zipperRouter.post(
	'/material-trx-against-order',
	materialTrxAgainstOrderOperations.insert
);
zipperRouter.put(
	'/material-trx-against-order/:uuid',
	materialTrxAgainstOrderOperations.update
);
zipperRouter.delete(
	'/material-trx-against-order/:uuid',
	materialTrxAgainstOrderOperations.remove
);
zipperRouter.get(
	'/material-trx-against-order/by/:trx_to',
	materialTrxAgainstOrderOperations.selectMaterialTrxLogAgainstOrderByTrxTo
);
zipperRouter.get(
	'/material-trx-against-order/multiple/by/:trx_tos',
	materialTrxAgainstOrderOperations.selectMaterialTrxAgainstOrderDescriptionByMultipleTrxTo
);

//.............Tape Coil To Dyeing.....................//
zipperRouter.get('/tape-coil-to-dyeing', tapeCoilToDyeingOperations.selectAll);
zipperRouter.get(
	'/tape-coil-to-dyeing/:uuid',
	// validateUuidParam(),
	tapeCoilToDyeingOperations.select
);
zipperRouter.post('/tape-coil-to-dyeing', tapeCoilToDyeingOperations.insert);
zipperRouter.put(
	'/tape-coil-to-dyeing/:uuid',
	tapeCoilToDyeingOperations.update
);
zipperRouter.delete(
	'/tape-coil-to-dyeing/:uuid',
	// validateUuidParam(),
	tapeCoilToDyeingOperations.remove
);
zipperRouter.get(
	'/tape-coil-to-dyeing/by/type/nylon',
	tapeCoilToDyeingOperations.selectTapeCoilToDyeingByNylon
);
zipperRouter.get(
	'/tape-coil-to-dyeing/by/type/tape',
	tapeCoilToDyeingOperations.selectTapeCoilToDyeingForTape
);

//.............Batch Production.....................//

zipperRouter.get('/batch-production', batchProductionOperations.selectAll);
zipperRouter.get(
	'/batch-production/:uuid',
	// validateUuidParam(),
	batchProductionOperations.select
);
zipperRouter.post('/batch-production', batchProductionOperations.insert);
zipperRouter.put('/batch-production/:uuid', batchProductionOperations.update);
zipperRouter.delete(
	'/batch-production/:uuid',
	// validateUuidParam(),
	batchProductionOperations.remove
);

// --------------------- MULTI COLOR DASHBOARD ROUTES ---------------------
zipperRouter.get(
	'/multi-color-dashboard',
	multiColorDashboardOperations.selectAll
);
zipperRouter.get(
	'/multi-color-dashboard/:uuid',
	multiColorDashboardOperations.select
);
zipperRouter.post(
	'/multi-color-dashboard',
	multiColorDashboardOperations.insert
);
zipperRouter.put(
	'/multi-color-dashboard/:uuid',
	multiColorDashboardOperations.update
);
zipperRouter.delete(
	'/multi-color-dashboard/:uuid',
	multiColorDashboardOperations.remove
);

// --------------------- MULTI COLOR TAPES RECEIVE ROUTES ---------------------
zipperRouter.get(
	'/multi-color-tape-receive',
	multiColorTapeReceiveOperations.selectAll
);
zipperRouter.get(
	'/multi-color-tape-receive/:uuid',
	multiColorTapeReceiveOperations.select
);
zipperRouter.post(
	'/multi-color-tape-receive',
	multiColorTapeReceiveOperations.insert
);
zipperRouter.put(
	'/multi-color-tape-receive/:uuid',
	multiColorTapeReceiveOperations.update
);
zipperRouter.delete(
	'/multi-color-tape-receive/:uuid',
	multiColorTapeReceiveOperations.remove
);

export { zipperRouter };
