import SE, { SED } from '../../../util/swagger_example.js';
//* ./schema.js#buyer
export const defPublicBuyer = SED({
	required: ['uuid', 'name'],
	properties: {
		uuid: SE.uuid(),
		name: SE.string('John Doe'),
		short_name: SE.string('JD'),
		remarks: SE.string('Remarks'),
	},
	xml: 'Public/Buyer',
});

export const defPublicParty = SED({
	required: ['uuid', 'name', 'short_name', 'created_at', 'created_by'],
	properties: {
		uuid: SE.uuid(),
		name: SE.string('John Doe'),
		short_name: SE.string('JD'),
		created_at: SE.date_time(),
		updated_at: SE.date_time(),
		created_by: SE.uuid(),
		remarks: SE.string('Remarks'),
	},
	xml: 'Public/Party',
});

export const defPublicMarketing = SED({
	required: ['uuid', 'name', 'user_uuid'],
	properties: {
		uuid: SE.uuid(),
		name: SE.string('John Doe'),
		short_name: SE.string('JD'),
		user_uuid: SE.uuid(),
		remarks: SE.string('Remarks'),
	},
	xml: 'Public/Marketing',
});

export const defPublicMerchandiser = SED({
	required: ['uuid', 'party_uuid', 'name', 'created_at'],
	properties: {
		uuid: SE.uuid(),
		party_uuid: SE.uuid(),
		name: SE.string('John Doe'),
		email: SE.string('johndoe@gmail.com'),
		phone: SE.string('123456789'),
		address: SE.string('Address'),
		created_at: SE.date_time(),
		updated_at: SE.date_time(),
	},
	xml: 'Public/Merchandiser',
});

export const defPublicFactory = SED({
	required: ['uuid', 'party_uuid', 'name', 'created_at'],
	properties: {
		uuid: SE.uuid(),
		party_uuid: SE.uuid(),
		name: SE.string('John Doe'),
		phone: SE.string('123456789'),
		address: SE.string('Address'),
		created_at: SE.date_time(),
		updated_at: SE.date_time(),
		created_by: SE.uuid(),
		remarks: SE.string('Remarks'),
	},
	xml: 'Public/Factory',
});

export const defPublicSection = SED({
	required: ['uuid', 'name'],
	properties: {
		uuid: SE.uuid(),
		name: SE.string('John Doe'),
		short_name: SE.string('JD'),
		remarks: SE.string('Remarks'),
	},
	xml: 'Public/Section',
});

export const defPublicProperties = SED({
	required: ['uuid', 'item_for', 'type', 'name', 'created_by', 'created_at'],
	properties: {
		uuid: SE.uuid(),
		item_for: SE.string('Item For'),
		type: SE.string('Type'),
		name: SE.string('Name'),
		short_name: SE.string('Short Name'),
		created_by: SE.uuid(),
		created_at: SE.date_time(),
		updated_at: SE.date_time(),
		remarks: SE.string('Remarks'),
	},
	xml: 'Public/Properties',
});

export const defThreadMachine = {
	type: 'object',
	required: [
		'uuid',
		'name',
		'max_capacity',
		'min_capacity',
		'created_by',
		'created_at',
	],

	properties: {
		uuid: {
			type: 'string',
			example: 'igD0v9DIJQhJeet',
		},
		name: {
			type: 'string',
			example: 'Machine Name',
		},
		is_nylon: {
			type: 'number',
			example: 1,
		},
		is_metal: {
			type: 'number',
			example: 1,
		},
		is_vislon: {
			type: 'number',
			example: 1,
		},
		is_sewing_thread: {
			type: 'number',
			example: 1,
		},
		is_bulk: {
			type: 'number',
			example: 1,
		},
		is_sample: {
			type: 'number',
			example: 1,
		},
		max_capacity: {
			type: 'number',
			example: 10.0,
		},
		min_capacity: {
			type: 'number',
			example: 10.0,
		},
		water_capacity: {
			type: 'number',
			example: 10.0,
		},
		created_by: {
			type: 'string',
			example: 'igD0v9DIJQhJeet',
		},
		created_at: {
			type: 'string',
			format: 'date-time',
			example: '2024-01-01 00:00:00',
		},
		updated_at: {
			type: 'string',
			format: 'date-time',
			example: '2024-01-01 00:00:00',
		},
		remarks: {
			type: 'string',
			example: 'Remarks',
		},
	},
	xml: {
		name: 'Thread/Machine',
	},
};

// * Marge All
export const defPublic = {
	buyer: defPublicBuyer,
	party: defPublicParty,
	marketing: defPublicMarketing,
	merchandiser: defPublicMerchandiser,
	factory: defPublicFactory,
	section: defPublicSection,
	properties: defPublicProperties,
};

// * Tag
export const tagPublic = [
	{
		name: 'public.buyer',
		description: 'buyer',
	},
	{
		name: 'public.party',
		description: 'party',
	},
	{
		name: 'public.marketing',
		description: 'marketing',
	},
	{
		name: 'public.merchandiser',
		description: 'merchandiser',
	},
	{
		name: 'public.factory',
		description: 'factory',
	},
	{
		name: 'public.section',
		description: 'section',
	},
	{
		name: 'public.properties',
		description: 'properties',
	},
	{
		name: 'public.machine',
		description: 'Thread Machine',
	},
];
