export interface Notification {
    docId: string;
    customerId: string;
    title: string;
    message: string;
    metadata: Record<string, any>;
    createdAt: Date;
    updatedAt: Date;
}