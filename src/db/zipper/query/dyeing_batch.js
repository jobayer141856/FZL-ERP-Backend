import { desc, eq, sql } from 'drizzle-orm';
import { createApi } from '../../../util/api.js';
import {
	handleError,
	handleResponse,
	validateRequest,
} from '../../../util/index.js';
import * as hrSchema from '../../hr/schema.js';
import db from '../../index.js';
import * as publicSchema from '../../public/schema.js';
import { decimalToNumber } from '../../variables.js';
import { dyeing_batch } from '../schema.js';

export async function insert(req, res, next) {
	if (!(await validateRequest(req, next))) return;

	const batchPromise = db
		.insert(dyeing_batch)
		.values(req.body)
		.returning({
			insertedUuid: sql`concat('B', to_char(dyeing_batch.created_at, 'YY'), '-', LPAD(dyeing_batch.id::text, 4, '0'))`,
		});
	try {
		const data = await batchPromise;

		const toast = {
			status: 201,
			type: 'insert',
			message: `${data[0].insertedUuid} inserted`,
		};

		res.status(201).json({ toast, data });
	} catch (error) {
		await handleError({ error, res });
	}
}

export async function update(req, res, next) {
	if (!(await validateRequest(req, next))) return;

	const batchPromise = db
		.update(dyeing_batch)
		.set(req.body)
		.where(eq(dyeing_batch.uuid, req.params.uuid))
		.returning({ updatedUuid: dyeing_batch.uuid });

	try {
		const data = await batchPromise;
		const toast = {
			status: 201,
			type: 'update',
			message: `${data[0].updatedUuid} updated`,
		};

		res.status(201).json({ toast, data });
	} catch (error) {
		await handleError({ error, res });
	}
}

export async function remove(req, res, next) {
	if (!(await validateRequest(req, next))) return;

	const batchPromise = db
		.delete(dyeing_batch)
		.where(eq(dyeing_batch.uuid, req.params.uuid))
		.returning({
			deletedUuid: sql`concat('B', to_char(dyeing_batch.created_at, 'YY'), '-', LPAD(dyeing_batch.id::text, 4, '0'))`,
		});

	try {
		const data = await batchPromise;
		const toast = {
			status: 201,
			type: 'delete',
			message: `${data[0].deletedUuid} deleted`,
		};

		res.status(200).json({ toast, data });
	} catch (error) {
		await handleError({ error, res });
	}
}

export async function selectAll(req, res, next) {
	const query = sql`
		SELECT 
			dyeing_batch.uuid,
			dyeing_batch.id,
			concat('B', to_char(dyeing_batch.created_at, 'YY'), '-', LPAD(dyeing_batch.id::text, 4, '0')) as batch_id,
			dyeing_batch.batch_status,
			dyeing_batch.machine_uuid,
			concat(public.machine.name, ' (', public.machine.min_capacity::float8, '-', public.machine.max_capacity::float8, ')') as machine_name,
			dyeing_batch.slot,
			dyeing_batch.received,
			dyeing_batch.created_by,
			users.name as created_by_name,
			dyeing_batch.created_at,
			dyeing_batch.updated_at,
			dyeing_batch.remarks,
			expected.total_quantity,
			expected.expected_kg,
			expected.order_numbers,
			expected.total_actual_production_quantity
		FROM zipper.dyeing_batch
		LEFT JOIN hr.users ON dyeing_batch.created_by = users.uuid
		LEFT JOIN public.machine ON dyeing_batch.machine_uuid = public.machine.uuid
		LEFT JOIN (
			SELECT 
				ROUND(
					SUM(((
						(tcr.top + tcr.bottom + CASE 
						WHEN vodf.is_inch = 1 
							THEN CAST(CAST(oe.size AS NUMERIC) * 2.54 AS NUMERIC) 
						ELSE CAST(oe.size AS NUMERIC)
						END) * be.quantity::float8) /100) / tc.dyed_per_kg_meter::float8)::numeric
				, 3) as expected_kg, 
				be.dyeing_batch_uuid, 
				jsonb_agg(DISTINCT vodf.order_number) as order_numbers, 
				SUM(be.quantity::float8) as total_quantity, 
				SUM(be.production_quantity_in_kg::float8) as total_actual_production_quantity
			FROM zipper.dyeing_batch_entry be
				LEFT JOIN zipper.sfg ON be.sfg_uuid = zipper.sfg.uuid
				LEFT JOIN zipper.order_entry oe ON sfg.order_entry_uuid = oe.uuid
				LEFT JOIN zipper.v_order_details_full vodf ON oe.order_description_uuid = vodf.order_description_uuid
				LEFT JOIN 
					zipper.tape_coil_required tcr ON oe.order_description_uuid = vodf.order_description_uuid AND vodf.item = tcr.item_uuid 
					AND vodf.zipper_number = tcr.zipper_number_uuid 
					AND vodf.end_type = tcr.end_type_uuid
				LEFT JOIN
					zipper.tape_coil tc ON  vodf.tape_coil_uuid = tc.uuid AND vodf.item = tc.item_uuid AND vodf.zipper_number = tc.zipper_number_uuid 
			WHERE CASE WHEN lower(vodf.item_name) = 'nylon' THEN vodf.nylon_stopper = tcr.nylon_stopper_uuid ELSE TRUE END
			GROUP BY be.dyeing_batch_uuid
		) AS expected ON dyeing_batch.uuid = expected.dyeing_batch_uuid
		ORDER BY dyeing_batch.created_at DESC
	`;
	const resultPromise = db.execute(query);

	try {
		const data = await resultPromise;
		const toast = {
			status: 200,
			type: 'select',
			message: 'dyeing_batch list',
		};
		res.status(200).json({ toast, data: data?.rows });
	} catch (error) {
		handleError({ error, res });
	}
}

export async function select(req, res, next) {
	if (!(await validateRequest(req, next))) return;

	const batchPromise = db
		.select({
			uuid: dyeing_batch.uuid,
			id: dyeing_batch.id,
			batch_id: sql`concat('B', to_char(dyeing_batch.created_at, 'YY'), '-', LPAD(dyeing_batch.id::text, 4, '0'))`,
			batch_status: dyeing_batch.batch_status,
			machine_uuid: dyeing_batch.machine_uuid,
			machine_name: publicSchema.machine.name,
			slot: dyeing_batch.slot,
			received: dyeing_batch.received,
			created_by: dyeing_batch.created_by,
			created_by_name: hrSchema.users.name,
			created_at: dyeing_batch.created_at,
			updated_at: dyeing_batch.updated_at,
			remarks: dyeing_batch.remarks,
		})
		.from(dyeing_batch)
		.leftJoin(
			hrSchema.users,
			eq(dyeing_batch.created_by, hrSchema.users.uuid)
		)
		.leftJoin(
			publicSchema.machine,
			eq(dyeing_batch.machine_uuid, publicSchema.machine.uuid)
		)
		.where(eq(dyeing_batch.uuid, req.params.uuid));

	try {
		const data = await batchPromise;
		const toast = {
			status: 200,
			type: 'select',
			message: 'dyeing_batch detail',
		};
		res.status(200).json({ toast, data: data[0] });
	} catch (error) {
		handleError({ error, res });
	}
}

export async function selectBatchDetailsByBatchUuid(req, res, next) {
	if (!validateRequest(req, next)) return;

	const { dyeing_batch_uuid } = req.params;

	console.log('dyeing_batch_uuid', dyeing_batch_uuid);

	try {
		const api = await createApi(req);
		const fetchData = async (endpoint) =>
			await api
				.get(`${endpoint}/${dyeing_batch_uuid}`)
				.then((response) => response);

		const [dyeing_batch, dyeing_batch_entry] = await Promise.all([
			fetchData('/zipper/dyeing-batch'),
			fetchData('/zipper/dyeing-batch-entry/by/dyeing-batch-uuid'),
		]);

		const response = {
			...dyeing_batch?.data?.data,
			dyeing_batch_entry: dyeing_batch_entry?.data?.data || [],
		};

		const toast = {
			status: 200,
			type: 'select',
			msg: 'Batch Details Full',
		};

		res.status(200).json({ toast, data: response });
	} catch (error) {
		await handleError({ error, res });
	}
}